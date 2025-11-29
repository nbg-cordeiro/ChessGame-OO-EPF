% rebase('layout.tpl', title='Configuração da Partida')

<link rel="stylesheet" href="/static/css/setup.css">

<div class="setup-wrapper">
    <div class="config-card">
        
        <h1 class="config-title">
            <i class="fas fa-cog" style="color: var(--text-color);"></i> Configuração
        </h1>
        
        % if defined('error') and error:
            <div class="alert-box">
                <i class="fas fa-exclamation-triangle"></i> {{error}}
            </div>
        % end
        
        <form action="/game/start" method="POST">
            
            <div class="mode-selector">
                <label class="radio-label">
                    <input type="radio" id="modo-casual" name="mode" value="casual" checked onchange="alternarCampos()">
                    Modo Casual
                </label>
                
                <label class="radio-label">
                    <input type="radio" id="modo-rankeado" name="mode" value="ranked" onchange="alternarCampos()">
                    Modo Rankeado
                </label>
            </div>
            
            <div id="campos-rankeado" class="inputs-area">
                <div class="info-text">
                    <i class="fas fa-info-circle"></i> Digite o ID dos jogadores cadastrados.
                </div>

                <div class="input-group">
                    <label for="p1">🆔 Jogador 1 (Brancas):</label>
                    <input type="number" id="p1" name="player1_id" placeholder="Ex: 1">
                </div>
                
                <div class="input-group">
                    <label for="p2">🆔 Jogador 2 (Pretas):</label>
                    <input type="number" id="p2" name="player2_id" placeholder="Ex: 2">
                </div>
            </div>
            
            <div class="actions">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="fas fa-play"></i> Começar Jogo
                </button>

                <a href="/menu" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Voltar ao Menu
                </a>
            </div>

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
            inputP1.required = false; 
            inputP2.required = false;
        } else {
            divCampos.style.display = 'none';
            inputP1.value = "";
            inputP2.value = "";
        }
    }
    
    document.addEventListener("DOMContentLoaded", alternarCampos);
</script>