% rebase('layout.tpl', title='Menu Principal')

<link rel="stylesheet" href="/static/css/menu.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="menu-wrapper">
    
    <div class="conteiner-menu">
    <h1 class="titulo-jogo">
        <i class="fas fa-chess-pawn" style="color: #4834d4;"></i> Xadrez Real
    </h1>

        <a href="/game/setup" class="botao-menu btn-iniciar_jogo">
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
            Cadastre-se <a href="/users/add">clicando aqui!</a>
        </div>
    </div>

</div>