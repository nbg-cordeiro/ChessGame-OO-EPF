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
        grid-template-columns: repeat(8, 70px);
        grid-template-rows: repeat(8, 70px);
        border: 10px solid #4a3424;
        border-radius: 4px;
        box-shadow: 0 10px 20px rgba(0,0,0,0.4);
    }

    .square {
        width: 70px;
        height: 70px;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        position: relative;
    }

    .white-cell { background-color: #eeeed2; color: #769656; }
    .black-cell { background-color: #769656; color: #eeeed2; }
    
    .selected { background-color: #baca44 !important; }

    /* ESTILO DAS IMAGENS DAS PEÇAS */
    .piece-img {
        width: 90%;
        height: 90%;
        transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        user-select: none;
        pointer-events: none; /* O clique atravessa a imagem */
    }

    .square:hover .piece-img {
        transform: scale(1.1);
        filter: drop-shadow(0 5px 5px rgba(0,0,0,0.3));
    }
    
    #status-msg {
        background-color: #333;
        color: white;
        padding: 10px 20px;
        border-radius: 20px;
        margin-bottom: 20px;
        font-weight: bold;
        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
    }
    
    .error { background-color: #c0392b !important; }

    /* Coordenadas */
    .board-wrapper { position: relative; display: inline-block; }
    .coords { position: absolute; font-size: 16px; font-weight: bold; font-family: sans-serif; pointer-events: none; color: #333; z-index: 5; }
    .coords-left { left: -25px; top: 0; height: 100%; display: flex; flex-direction: column; justify-content: space-around; }
    .coords-bottom { bottom: -25px; left: 0; width: 100%; display: flex; justify-content: space-around; }
</style>

<div class="chess-container">
    <div id="status-msg">Vez das Brancas</div>

    <div class="board-wrapper">
        <div class="coords coords-left">
            % for num in range(8, 0, -1):
                <div>{{num}}</div>
            % end
        </div>

        <div id="tabuleiro">
            % columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
            
            % color_map = {'white': 'w', 'black': 'b'}
            % type_map = {'Pawn': 'P', 'Rook': 'R', 'Knight': 'N', 'Bishop': 'B', 'Queen': 'Q', 'King': 'K'}

            % for r, row in enumerate(board):
                % for c, piece in enumerate(row):
                    % color_class = "white-cell" if (r + c) % 2 == 0 else "black-cell"
                    % pos_id = f"{columns[c]}{8 - r}"

                    <div class="square {{color_class}}" id="{{pos_id}}" onclick="handleClick('{{pos_id}}')">
                        % if piece:
                            % filename = f"{color_map[piece['color']]}{type_map[piece['type']]}"
                            <img src="/static/img/pieces/{{filename}}.svg" 
                                 class="piece-img" 
                                 alt="{{piece['type']}}">
                        % end
                    </div>
                % end
            % end
        </div>

        <div class="coords coords-bottom">
            % for col in ['a','b','c','d','e','f','g','h']:
                <div>{{col}}</div>
            % end
        </div>
    </div>

    <br>
    <button onclick="resetGame()" class="btn-submit" style="cursor: pointer; padding: 12px 25px; font-size: 16px;">
        <i class="fas fa-undo"></i> Reiniciar Partida
    </button>
</div>

<script>
    const sndMove = new Audio('/static/audio/move.mp3');
    const sndCapture = new Audio('/static/audio/captura.mp3');
    const sndCheck = new Audio('/static/audio/check.mp3');
    const sndMate = new Audio('/static/audio/checkmate.mp3');
    
    let selectedCell = null;

    async function handleClick(position) {
        const cell = document.getElementById(position);
        const statusDiv = document.getElementById('status-msg');
        statusDiv.className = ""; 

        // 1. Seleção
        if (!selectedCell) {
            if (cell.querySelector('img')) {
                selectedCell = position;
                cell.classList.add('selected');
            }
            return;
        }

        // 2. Cancelar
        if (selectedCell === position) {
            clearSelection();
            return;
        }

        // 3. Mover
        statusDiv.innerText = "Calculando...";
        
        try {
            const pecasAntes = document.querySelectorAll('.piece-img').length;

            const response = await fetch('/move', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ start: selectedCell, end: position })
            });

            const data = await response.json();

            if (data.valid) {
                updateBoard(data.board);
                

                const pecasDepois = document.querySelectorAll('.piece-img').length;
                const houveCaptura = pecasDepois < pecasAntes;

                let msg = `Vez das: ${data.turn === 'white' ? 'Brancas' : 'Pretas'}`;
                
    
                if (data.mate) {
                    playSound(sndMate);
                    msg = `XEQUE-MATE! Vencedor: ${data.turn === 'white' ? 'Pretas' : 'Brancas'}`;
                    alert("FIM DE JOGO: " + msg);
                    
                } else if (data.check) {
                    playSound(sndCheck);
                    msg += " (XEQUE!)";
                    statusDiv.style.backgroundColor = "#d35400";
                    
                } else if (houveCaptura) {
                    playSound(sndCapture);
                    statusDiv.style.backgroundColor = "#333";
                    
                } else if (data.stalemate || data.draw) {
                    playSound(sndMate); 
                    msg = "EMPATE!";
                    alert(msg);
                    
                } else {
                    playSound(sndMove);
                    statusDiv.style.backgroundColor = "#333";
                }
                
                statusDiv.innerText = msg;

            } else {
                statusDiv.innerText = `Erro: ${data.error}`;
                statusDiv.classList.add("error");
            }
        } catch (error) {
            console.error(error);
            statusDiv.innerText = "Erro de conexão.";
        }

        clearSelection();
    }
    
    function playSound(audioObj) {
        audioObj.currentTime = 0;
        audioObj.play().catch(e => console.log("Som bloqueado"));
    }

    function clearSelection() {
        if (selectedCell) {
            const cell = document.getElementById(selectedCell);
            if(cell) cell.classList.remove('selected');
            selectedCell = null;
        }
    }

    function updateBoard(matrix) {
        const columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        const colorMap = {'white': 'w', 'black': 'b'};
        const typeMap = {'Pawn': 'P', 'Rook': 'R', 'Knight': 'N', 'Bishop': 'B', 'Queen': 'Q', 'King': 'K'};

        for (let r = 0; r < 8; r++) {
            for (let c = 0; c < 8; c++) {
                const piece = matrix[r][c];
                const posId = `${columns[c]}${8 - r}`;
                const cell = document.getElementById(posId);
                
                cell.innerHTML = ""; 
                
                if (piece) {
                    const img = document.createElement('img');
                    const filename = colorMap[piece.color] + typeMap[piece.type];
                    img.src = `/static/img/pieces/${filename}.svg`;
                    img.className = "piece-img";
                    img.alt = piece.type;
                    cell.appendChild(img);
                }
            }
        }
    }
    
    async function resetGame() {
        if(confirm("Reiniciar o jogo atual?")) {
            await fetch('/reset', {method: 'POST'});
            window.location.reload();
        }
    }
</script>