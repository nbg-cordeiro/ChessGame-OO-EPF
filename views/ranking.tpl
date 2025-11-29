% rebase('layout.tpl', title='Ranking de Jogadores')

<link rel="stylesheet" href="/static/css/ranking.css">

<div class="ranking-wrapper">
    <div class="ranking-card">
        
        <h1 class="ranking-title">🏆 Hall da Fama</h1>
        <p class="ranking-subtitle">Os grandes mestres do tabuleiro.</p>

        <div class="table-responsive">
            <table class="ranking-table">
                <thead>
                    <tr>
                        <th width="15%" style="text-align: center;">Posição</th>
                        <th width="60%" style="text-align: left; padding-left: 20px;">Jogador</th>
                        <th width="25%" style="text-align: right; padding-right: 20px;">Pontuação</th>
                    </tr>
                </thead>
                <tbody>
                    % for i, player in enumerate(players):
                        % pos = i + 1
                        % row_class = f"row-{pos}" if pos <= 3 else ""
                        
                        <tr class="{{row_class}}">
                            <td class="rank-pos">
                                % if pos == 1:
                                    <i class="fas fa-crown gold"></i>
                                % elif pos == 2:
                                    <i class="fas fa-medal silver"></i>
                                % elif pos == 3:
                                    <i class="fas fa-medal bronze"></i>
                                % else:
                                    <span class="normal-pos">#{{pos}}</span>
                                % end
                            </td>

                            <td>
                                <div class="player-cell">
                                    <div class="avatar-small">
                                        {{player['name'][0].upper()}}
                                    </div>
                                    {{player['name']}}
                                </div>
                            </td>

                            <td class="score-cell" style="text-align: right; padding-right: 20px;">
                                {{player['score']}}
                            </td>
                        </tr>
                    % end
                    
                    % if not players:
                        <tr>
                            <td colspan="3" class="empty-state">
                                <i class="fas fa-chess-board"></i>
                                Ainda não há jogadores rankeados.<br>
                                <a href="/users/add" style="color: var(--secondary-color); font-weight: bold;">Seja o primeiro!</a>
                            </td>
                        </tr>
                    % end
                </tbody>
            </table>
        </div>

        <div style="margin-top: 30px;">
            <a href="/menu" class="btn btn-secondary" style="width: auto; padding-left: 40px; padding-right: 40px;">
                <i class="fas fa-arrow-left"></i> Voltar ao Menu
            </a>
        </div>

    </div>
</div>