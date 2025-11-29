% rebase('layout.tpl', title='Menu Principal')
<link rel="stylesheet" href="/static/css/menu.css">

<div class="center-wrapper">
    <div class="card-container menu-card">
        
        <h1 class="titulo-menu">
            <i class="fas fa-chess-pawn" style="color: #4834d4;"></i> Xadrez Real
        </h1>

        <a href="/game/setup" class="btn btn-primary btn-lg">
            <i class="fas fa-chess-board"></i> Iniciar Jogo
        </a>

        <a href="/users" class="btn btn-info btn-lg">
            <i class="fas fa-user-plus"></i> Jogadores
        </a>

        <a href="/ranking" class="btn btn-warning btn-lg">
            <i class="fas fa-trophy"></i> Ver Ranking
        </a>
        
        <div style="margin-top: 20px; color: #999;">
            Não é um jogador? <a href="/users/add" style="color: var(--secondary-color);">Cadastre-se aqui</a>
        </div>

    </div>
</div>