<link rel="stylesheet" href="/static/css/game.css">

<div class="game-layout">
    
    <div class="board-column">
        
        <div class="player-info">
            <div class="avatar-icon" style="background-color: #333; color: white;">
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
            <div class="avatar-icon" style="background-color: #fff; color: #333;">
                <i class="fas fa-user"></i>
            </div>
            <span>{{player1}}</span>
        </div>
    </div>

    <div class="sidebar-column">
        <div id="status-card">
            <span class="status-label">Status da Partida</span>
            <span id="status-text">Vez das Brancas</span>
        </div>

        <hr style="border: 0; border-top: 1px solid #eee; margin: 10px 0;">

        <button onclick="resetGame()" class="btn-game btn-restart">
            <i class="fas fa-undo"></i> Reiniciar Partida
        </button>

        <a href="/menu" class="btn-game btn-menu">
            <i class="fas fa-bars"></i> Voltar ao Menu
        </a>
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

        if (!selectedCell) {
            if (cell.querySelector('img')) {
                selectedCell = position;
                cell.classList.add('selected');
            }
            return;
        }

        if (selectedCell === position) {
            clearSelection();
            return;
        }

        statusText.innerText = "Calculando...";
        
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
                
                statusCard.style.backgroundColor = "#2c3e50";

                if (data.mate) {
                    playSound(sndMate);
                    msg = `XEQUE-MATE! Vencedor: ${data.turn === 'white' ? 'Pretas' : 'Brancas'}`;
                    statusCard.style.backgroundColor = "#c0392b"; 
                    alert("FIM DE JOGO: " + msg);
                } else if (data.check) {
                    playSound(sndCheck);
                    msg += " (XEQUE!)";
                    statusCard.style.backgroundColor = "#d35400"; 
                } else if (houveCaptura) {
                    playSound(sndCapture);
                } else if (data.stalemate || data.draw) {
                    playSound(sndMate); 
                    msg = "EMPATE!";
                    statusCard.style.backgroundColor = "#7f8c8d"; 
                    alert(msg);
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
        audioObj.play().catch(e => console.log("Som bloqueado pelo navegador"));
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