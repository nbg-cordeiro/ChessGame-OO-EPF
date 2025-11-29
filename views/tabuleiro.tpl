% rebase('layout.tpl', title='Jogo de Xadrez')

<style>
    /* Layout Principal */
    .game-wrapper {
        display: flex;
        justify-content: center;
        padding: 40px 20px;
        min-height: 100vh;
        box-sizing: border-box;
        background-color: #f4f6f8; /* Fundo cinza claro */
    }

    .game-layout {
        display: flex;
        justify-content: center;
        align-items: flex-start; 
        gap: 60px; /* Espaço entre o tabuleiro e o painel */
        flex-wrap: wrap; 
        width: 100%;
        max-width: 1200px;
    }

    /* --- COLUNA ESQUERDA (TABULEIRO) --- */
    .board-column {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 20px;
    }

    /* Tabuleiro Grid */
    #tabuleiro {
        display: grid;
        grid-template-columns: repeat(8, 70px);
        grid-template-rows: repeat(8, 70px);
        border: 10px solid #4a3424; /* Moldura de madeira */
        border-radius: 4px;
        box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        user-select: none;
        background-color: #4a3424;
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

    /* Cores das Casas */
    .white-cell { background-color: #eeeed2; }
    .black-cell { background-color: #769656; }
    .selected { background-color: #baca44 !important; }

    /* Peças */
    .piece-img {
        width: 90%;
        height: 90%;
        transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        pointer-events: none;
    }
    .square:hover .piece-img { transform: scale(1.15); filter: drop-shadow(0 5px 5px rgba(0,0,0,0.2)); }

    /* Coordenadas */
    .board-wrapper { position: relative; display: inline-block; }
    .coords { position: absolute; font-size: 14px; font-weight: 700; font-family: sans-serif; pointer-events: none; color: #333; z-index: 5; opacity: 0.6; }
    .coords-left { left: -25px; top: 0; height: 100%; display: flex; flex-direction: column; justify-content: space-around; }
    .coords-bottom { bottom: -25px; left: 0; width: 100%; display: flex; justify-content: space-around; }

    /* --- CARDS DE JOGADOR (Balões) --- */
    .player-info {
        display: flex;
        align-items: center;
        gap: 15px;
        background-color: white;
        padding: 10px 25px;
        border-radius: 50px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        border: 1px solid #eee;
        width: 100%;
        box-sizing: border-box;
        justify-content: center;
        font-weight: 700;
        color: #2c3e50;
        font-size: 1.1rem;
    }

    .avatar-icon {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 0.9em;
        color: white;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    /* --- COLUNA DIREITA (PAINEL) --- */
    .sidebar-column {
        width: 320px;
        display: flex;
        flex-direction: column;
        gap: 20px;
        background-color: white;
        padding: 30px;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        border: 1px solid #eee;
        height: fit-content;
        margin-top: 20px;
    }

    /* Card de Status */
    #status-card {
        background-color: #2c3e50;
        color: white;
        padding: 25px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: background-color 0.3s ease;
    }

    #status-text {
        font-size: 1.4rem;
        font-weight: 800;
        display: block;
    }

    .status-label {
        font-size: 0.75rem;
        text-transform: uppercase;
        opacity: 0.7;
        letter-spacing: 1px;
        margin-bottom: 5px;
        display: block;
    }

    /* Botões Locais (Garantia de funcionamento) */
    .btn-local {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        width: 100%;
        padding: 15px;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 700;
        cursor: pointer;
        text-decoration: none;
        transition: transform 0.2s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        color: white;
        box-sizing: border-box;
    }
    .btn-local:hover { transform: translateY(-2px); }

    .btn-restart { background-color: #c0392b; } /* Vermelho */
    .btn-restart:hover { background-color: #a93226; }

    .btn-menu { background-color: #7f8c8d; } /* Cinza */
    .btn-menu:hover { background-color: #616e6e; }

    .error { background-color: #c0392b !important; }

    /* Responsividade */
    @media (max-width: 900px) {
        .game-layout { flex-direction: column; align-items: center; gap: 30px; }
        .sidebar-column { width: 100%; max-width: 400px; order: -1; }
    }
</style>

<div class="game-wrapper">
    <div class="game-layout">
        
        <div class="board-column">
            
            <div class="player-info">
                <div class="avatar-icon" style="background-color: #333;">
                    <i class="fas fa-user"></i>
                </div>
                <span>{{player2}}</span>
            </div>

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
                                    <img src="/static/img/pieces/{{filename}}.svg" class="piece-img" alt="{{piece['type']}}">
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

            <div class="player-info">
                <div class="avatar-icon" style="background-color: #999;">
                    <i class="fas fa-user"></i>
                </div>
                <span>{{player1}}</span>
            </div>
        </div>

        <div class="sidebar-column">
            
            <div id="status-card">
                <span class="status-label">STATUS DA PARTIDA</span>
                <span id="status-text">Vez das Brancas</span>
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 10px 0;">

            <button onclick="resetGame()" class="btn-local btn-restart">
                <i class="fas fa-undo"></i> Reiniciar Partida
            </button>

            <a href="/menu" class="btn-local btn-menu">
                <i class="fas fa-home"></i> Voltar ao Menu
            </a>
        </div>

    </div>
</div>

<script>
    const sndMove = new Audio('/static/audio/move.mp3');
    const sndCapture = new Audio('/static/audio/captura.mp3');
    const sndCheck = new Audio('/static/audio/check.mp3');
    const sndMate = new Audio('/static/audio/checkmate.mp3');
    
    let selectedCell = null;

    async function handleClick(position) {
        const cell = document.getElementById(position);
        const statusCard = document.getElementById('status-card');
        const statusText = document.getElementById('status-text');
        
        statusCard.className = ""; 

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
        statusText.innerText = "Calculando...";
        
        try {
            // Contar peças antes
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
                
                statusCard.style.backgroundColor = "#2c3e50"; // Azul normal

                if (data.mate) {
                    playSound(sndMate);
                    msg = `XEQUE-MATE! Vencedor: ${data.turn === 'white' ? 'Pretas' : 'Brancas'}`;
                    statusCard.style.backgroundColor = "#c0392b"; 
                    alert("FIM DE JOGO: " + msg);
                } else if (data.afogamento || data.empate) {
                    playSound(sndMate); 
                    msg = "EMPATE!";
                    statusCard.style.backgroundColor = "#7f8c8d"; 
                    alert(msg);
                } else if (data.check) {
                    playSound(sndCheck);
                    msg += " (XEQUE!)";
                    statusCard.style.backgroundColor = "#d35400"; 
                } else if (houveCaptura) {
                    playSound(sndCapture);
                } else {
                    playSound(sndMove);
                }
                
                statusText.innerText = msg;
            } else {
                statusText.innerText = `Erro: ${data.error}`;
                statusCard.style.backgroundColor = "#c0392b";
            }
        } catch (error) {
            console.error(error);
            statusText.innerText = "Erro de conexão.";
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