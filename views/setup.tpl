
<style>

    .caixa-config {
        background-color: white;
        padding: 40px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 500px; 
        margin: 40px auto;
        text-align: center;
        border: 1px solid #ddd;
    }

    h2 {
        color: #2c3e50;
        margin-bottom: 30px;
        font-size: 2rem;
    }

   
    .selecao-modo {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-bottom: 30px;
        background-color: #f1f2f6;
        padding: 15px;
        border-radius: 10px;
    }

    .opcao-radio {
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        font-weight: bold;
        color: #555;
    }

    input[type="radio"] {
        transform: scale(1.4); 
        accent-color: #27ae60; 
    }

 
    .area-jogadores {
        display: none; 
        flex-direction: column;
        gap: 15px;
        margin-bottom: 25px;
        text-align: left;
        background-color: #fff3cd;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #ffeeba;
    }

    .grupo-input label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #856404;
    }

    .grupo-input input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 1rem;
    }


    .btn-iniciar {
        background-color: #27ae60;
        color: white;
        border: none;
        padding: 15px 40px;
        font-size: 1.2rem;
        font-weight: bold;
        border-radius: 30px;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
        width: 100%;
    }

    .btn-iniciar:hover {
        background-color: #219150;
        transform: translateY(-2px);
    }
</style>

<div class="caixa-config">
    <h2>⚙️ Configuração da Partida</h2>
    
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
            <div style="font-size: 0.9em; margin-bottom: 10px; color: #856404;">
                <i class="fas fa-info-circle"></i> Insira o ID dos jogadores cadastrados.
            </div>

            <div class="grupo-input">
                <label for="p1">🆔 ID Jogador 1 (Peças Brancas):</label>
                <input type="number" id="p1" name="player1_id" placeholder="Ex: 1">
            </div>
            
            <div class="grupo-input">
                <label for="p2">🆔 ID Jogador 2 (Peças Pretas):</label>
                <input type="number" id="p2" name="player2_id" placeholder="Ex: 2">
            </div>
        </div>
        
        <button type="submit" class="btn-iniciar">
            <i class="fas fa-play"></i> Começar Jogo
        </button>
    </form>
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