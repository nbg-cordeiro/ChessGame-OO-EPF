<link rel="stylesheet" href="/static/css/setup.css">

<div class="setup-container">
    <div class="caixa-config">
        <h2><i class="fas fa-cog"></i> Configuração da Partida</h2>
        
        <form action="/game/start" method="POST">
            
            <div class="selecao-modo">
                <label class="opcao-radio">
                    <input type="radio" id="modo-casual" name="mode" value="casual" checked onchange="alternarCampos()">
                    Modo Casual
                </label>
                
                <label class="opcao-radio">
                    <input type="radio" id="modo-rankeado" name="mode" value="ranked" onchange="alternarCampos()">
                    Modo Rankeado
                </label>
            </div>
            
            <div id="campos-rankeado" class="area-jogadores">
                <div style="font-size: 0.9em; margin-bottom: 10px; color: #f57f17;">
                    <i class="fas fa-info-circle"></i> Insira o ID dos jogadores cadastrados.
                </div>

                <div class="grupo-input">
                    <label for="p1">🆔 ID Jogador 1 (Brancas):</label>
                    <input type="number" id="p1" name="player1_id" placeholder="Ex: 1">
                </div>
                
                <div class="grupo-input">
                    <label for="p2">🆔 ID Jogador 2 (Pretas):</label>
                    <input type="number" id="p2" name="player2_id" placeholder="Ex: 2">
                </div>
            </div>
            
            <button type="submit" class="btn-iniciar">
                <i class="fas fa-play"></i> Começar Jogo
            </button>
            <a href="/menu" class="btn-voltar-menu">
                 <i class="fas fa-arrow-left"></i> Voltar ao Menu Principal
            </a>
        </form>
    </div>
</div>

<script>
    function alternarCampos() {
        const isRankeado = document.getElementById('modo-rankeado').checked;
        const divCampos = document.getElementById('campos-rankeado');
        const inputP1 = document.getElementById('p1');
        const inputP2 = document.getElementById('p2');
        
        if (isRankeado) {
            divCampos.style.display = 'flex';
            inputP1.required = true;
            inputP2.required = true;
        } else {
            divCampos.style.display = 'none';
            inputP1.required = false;
            inputP2.required = false;
            inputP1.value = "";
            inputP2.value = "";
        }
    }
    
    document.addEventListener("DOMContentLoaded", alternarCampos);
</script>