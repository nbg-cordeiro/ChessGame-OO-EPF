
<style>
    .conteiner-menu {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin-top: 40px;
        gap: 25px; 
    }

    .titulo-jogo {
        font-size: 3.5rem;
        color: #2c3e50;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        margin-bottom: 20px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }


    .botao-menu {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 350px;
        padding: 18px;
        text-decoration: none;
        font-size: 1.4rem;
        font-weight: bold;
        border-radius: 12px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        border: 2px solid transparent;
    }


    .botao-menu i {
        margin-right: 15px;
        font-size: 1.6rem;
    }

    .btn-jogar {
        background-color: #27ae60;
        color: white;
    }
    .btn-jogar:hover {
        background-color: #219150;
        transform: scale(1.08); 
        box-shadow: 0 6px 10px rgba(0,0,0,0.2);
    }

    .btn-jogadores {
        background-color: #2980b9;
        color: white;
    }
    .btn-jogadores:hover {
        background-color: #2472a4;
        transform: translateY(-3px);
    }

    .btn-ranking {
        background-color: #f39c12;
        color: white;
    }
    .btn-ranking:hover {
        background-color: #d35400;
        transform: translateY(-3px);
    }

</style>

<div class="conteiner-menu">
    <h1 class="titulo-jogo">♟️ Xadrez Real</h1>

    <a href="/game/setup" class="botao-menu btn-jogar">
        <i class="fas fa-chess-board"></i> Iniciar Jogo
    </a>

    <a href="/users" class="botao-menu btn-jogadores">
        <i class="fas fa-user-plus"></i> Jogadores
    </a>

    <a href="/ranking" class="botao-menu btn-ranking">
        <i class="fas fa-trophy"></i> Ver Ranking
    </a>
    
    <div class="rodape-menu">
        Não é um jogador?
        Cadastre-se <a href="/users/add"> clicando aqui!</a>
    </div>
</div>    