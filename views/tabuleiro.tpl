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
</style>

<div class="chess-container">
    <div id="status-msg">Vez das Brancas</div>

    <div id="tabuleiro">
        % # Dicionário para traduzir Classes Python -> Símbolos Unicode do Xadrez
        % symbols = {
        %   'white': {'King': '&#9812;', 'Queen': '&#9813;', 'Rook': '&#9814;', 'Bishop': '&#9815;', 'Knight': '&#9816;', 'Pawn': '&#9817;'},
        %   'black': {'King': '&#9818;', 'Queen': '&#9819;', 'Rook': '&#9820;', 'Bishop': '&#9821;', 'Knight': '&#9822;', 'Pawn': '&#9823;'}
        % }
        % columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        
        % for r, row in enumerate(board):
            % for c, piece in enumerate(row):
                % # Calcula se a casa é branca ou preta
                % color_class = "white-cell" if (r + c) % 2 == 0 else "black-cell"
                
                % # Cria o ID tipo "a1", "h8" para o JavaScript achar a casa
                % pos_id = f"{columns[c]}{8 - r}"
                
                <div class="square {{color_class}}" 
                     id="{{pos_id}}" 
                     onclick="handleClick('{{pos_id}}')">
                    
                    % if piece:
                        {{!symbols[piece['color']][piece['type']]}}
                    % end
                </div>
            % end
        % end
    </div>
    
    <br>
    <button onclick="resetGame()" class="btn-submit" style="cursor: pointer; padding: 10px;">Reiniciar Jogo</button>
</div>

<script>
    let selectedCell = null;

    async function handleClick(position) {
        const cell = document.getElementById(position);
        const statusDiv = document.getElementById('status-msg');
        statusDiv.className = ""; // Tira cor de erro

        // --- CENA 1: Primeiro Clique (Selecionar Peça) ---
        if (!selectedCell) {
            // Só seleciona se tiver algo escrito dentro (uma peça)
            if (cell.innerText.trim() !== "") {
                selectedCell = position;
                cell.classList.add('selected');
                statusDiv.innerText = `Selecionado: ${position}. Clique no destino.`;
            }
            return;
        }

        // --- CENA 2: Clicou na mesma casa (Cancelar) ---
        if (selectedCell === position) {
            clearSelection();
            statusDiv.innerText = "Seleção cancelada.";
            return;
        }

        // --- CENA 3: Segundo Clique (Tentar Mover) ---
        statusDiv.innerText = "Processando...";
        
        try {
            // Manda os dados pro Python (GameController)
            const response = await fetch('/move', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ start: selectedCell, end: position })
            });

            const data = await response.json();

            if (data.valid) {
                updateBoard(data.board);
                
                let msg = `Vez das: ${data.turn === 'white' ? 'Brancas' : 'Pretas'}`;
                
                // Verifica XEQUE
                if (data.check) {
                    msg += " (XEQUE!)";
                    document.body.style.backgroundColor = "#5a2e2e"; // Fundo avermelhado de tensão
                } else {
                    document.body.style.backgroundColor = "#2c3e50"; // Volta ao normal
                }

                // --- NOVIDADE: Verifica MATE ---
                if (data.mate) {
                    msg = `XEQUE-MATE! Vencedor: ${data.turn === 'white' ? 'Pretas' : 'Brancas'}`;
                    alert("FIM DE JOGO: " + msg);
                    // Opcional: Bloquear o tabuleiro
                    document.getElementById('tabuleiro').style.pointerEvents = 'none';
                }
                
                statusDiv.innerText = msg;
                
            } else {
                // Se o Python proibiu (movimento ilegal)
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

    // Função que redesenha as peças baseada na Matriz nova que veio do Python
    function updateBoard(matrix) {
        const columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        
        // Dicionário igual ao do Python para traduzir JSON -> Unicode
        const symbols = {
            'white': {'King': '&#9812;', 'Queen': '&#9813;', 'Rook': '&#9814;', 'Bishop': '&#9815;', 'Knight': '&#9816;', 'Pawn': '&#9817;'},
            'black': {'King': '&#9818;', 'Queen': '&#9819;', 'Rook': '&#9820;', 'Bishop': '&#9821;', 'Knight': '&#9822;', 'Pawn': '&#9823;'}
        };

        for (let r = 0; r < 8; r++) {
            for (let c = 0; c < 8; c++) {
                const piece = matrix[r][c];
                const posId = `${columns[c]}${8 - r}`;
                const cell = document.getElementById(posId);
                
                cell.innerHTML = ""; // Limpa a casa
                
                if (piece) {
                    // Pega o código unicode correto
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