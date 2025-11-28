% rebase('layout.tpl', title='Jogo de Xadrez')

<style>
    .chess-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-top: 20px;
    }

    #tabuleiro {
        display: grid;
        grid-template-columns: repeat(8, 60px);
        grid-template-rows: repeat(8, 60px);
        border: 4px solid #333;
        box-shadow: 0 0 10px rgba(0,0,0,0.5);
    }

    .square {
        width: 60px;
        height: 60px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 40px;
        cursor: pointer;
        user-select: none;
    }

    .white-cell { background-color: #f0d9b5; }
    .black-cell { background-color: #b58863; }
    
    .selected {
        background-color: #7b68ee !important; /* Cor de destaque quando clica */
    }

    .square:hover {
        filter: brightness(1.1);
    }
    
    #status-msg {
        margin-bottom: 10px;
        font-weight: bold;
        font-size: 1.2em;
        height: 30px;
    }
    
    .error { color: red; }

 /* --- ADICIONADO: coordenadas do tabuleiro --- */
    .board-wrapper {
        position: relative;
        display: inline-block;
    }

    .coords {
        position: absolute;
        font-size: 16px;
        font-weight: bold;
        font-family: sans-serif;
        pointer-events: none;
        color: #333;
        z-index: 5;
    }

    .coords-left {
        left: -25px;
        top: 0;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .coords-bottom {
        bottom: -25px;
        left: 0;
        width: 100%;
        display: flex;
        justify-content: space-between;
    }
</style>


<!-- Código HTML+JS organizado com coordenadas ao redor do tabuleiro -->
<div class="chess-container">
    <div id="status-msg">Vez das Brancas</div>

    <div class="board-wrapper">

        <!-- Números à esquerda -->
        <div class="coords coords-left">
            % for num in range(8, 0, -1):
                <div>{{num}}</div>
            % end
        </div>

        <!-- TABULEIRO -->
        <div id="tabuleiro">
            % symbols = {
            %   'white': {'King': '&#9812;', 'Queen': '&#9813;', 'Rook': '&#9814;', 'Bishop': '&#9815;', 'Knight': '&#9816;', 'Pawn': '&#9817;'},
            %   'black': {'King': '&#9818;', 'Queen': '&#9819;', 'Rook': '&#9820;', 'Bishop': '&#9821;', 'Knight': '&#9822;', 'Pawn': '&#9823;'}
            % }
            % columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

            % for r, row in enumerate(board):
                % for c, piece in enumerate(row):
                    % color_class = "white-cell" if (r + c) % 2 == 0 else "black-cell"
                    % pos_id = f"{columns[c]}{8 - r}"

                    <div class="square {{color_class}}" id="{{pos_id}}" onclick="handleClick('{{pos_id}}')">
                        % if piece:
                            {{!symbols[piece['color']][piece['type']]}}
                        % end
                    </div>
                % end
            % end
        </div>

        <!-- Letras embaixo -->
        <div class="coords coords-bottom">
            % for col in ['a','b','c','d','e','f','g','h']:
                <div>{{col}}</div>
            % end
        </div>

    </div>

    <br>
    <button onclick="resetGame()" class="btn-submit" style="cursor: pointer; padding: 10px;">Reiniciar Jogo</button>
</div>

<script>
let selectedCell = null;

async function handleClick(position) {
    const cell = document.getElementById(position);
    const statusDiv = document.getElementById('status-msg');
    statusDiv.className = "";

    if (!selectedCell) {
        if (cell.innerText.trim() !== "") {
            selectedCell = position;
            cell.classList.add('selected');
            statusDiv.innerText = `Selecionado: ${position}. Clique no destino.`;
        }
        return;
    }

    if (selectedCell === position) {
        clearSelection();
        statusDiv.innerText = "Seleção cancelada.";
        return;
    }

    statusDiv.innerText = "Processando...";

    try {
        const response = await fetch('/move', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ start: selectedCell, end: position })
        });

        const data = await response.json();

        if (data.valid) {
            updateBoard(data.board);

            let msg = `Vez das: ${data.turn === 'white' ? 'Brancas' : 'Pretas'}`;

            if (data.check) {
                msg += " (XEQUE!)";
                document.body.style.backgroundColor = "#5a2e2e";
            } else {
                document.body.style.backgroundColor = "#2c3e50";
            }

            if (data.mate) {
                msg = `XEQUE-MATE! Vencedor: ${data.turn === 'white' ? 'Pretas' : 'Brancas'}`;
                alert("FIM DE JOGO: " + msg);
                document.getElementById('tabuleiro').style.pointerEvents = 'none';
            }
            else if(data.afogamento){
                msg = `Afogamento! O jogo empatou!`;
                alert("FIM DE JOGO: " + msg);
                document.getElementById('tabuleiro').style.pointerEvents = 'none';
            }
            else if(data.empate){
                msg = `O jogo empatou!`;
                alert("FIM DE JOGO: " + msg);
                document.getElementById('tabuleiro').style.pointerEvents = 'none';
            }

            statusDiv.innerText = msg;
        } else {
            statusDiv.innerText = `Erro: ${data.error}`;
            statusDiv.classList.add("error");
        }
    } catch (error) {
        console.error(error);
        statusDiv.innerText = "Erro de conexão com o servidor.";
    }

    clearSelection();
}

function clearSelection() {
    if (selectedCell) {
        document.getElementById(selectedCell).classList.remove('selected');
        selectedCell = null;
    }
}

function updateBoard(matrix) {
    const columns = ['a','b','c','d','e','f','g','h'];
    const symbols = {
        'white': {'King':'&#9812;','Queen':'&#9813;','Rook':'&#9814;','Bishop':'&#9815;','Knight':'&#9816;','Pawn':'&#9817;'},
        'black': {'King':'&#9818;','Queen':'&#9819;','Rook':'&#9820;','Bishop':'&#9821;','Knight':'&#9822;','Pawn':'&#9823;'}
    };

    for (let r = 0; r < 8; r++) {
        for (let c = 0; c < 8; c++) {
            const piece = matrix[r][c];
            const posId = `${columns[c]}${8 - r}`;
            const cell = document.getElementById(posId);

            cell.innerHTML = "";

            if (piece) {
                cell.innerHTML = symbols[piece.color][piece.type];
            }
        }
    }
}

async function resetGame() {
    await fetch('/reset', {method: 'POST'});
    window.location.reload();
}
</script>
