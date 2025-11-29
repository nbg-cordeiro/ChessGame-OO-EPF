% rebase('layout.tpl', title='Ranking de Jogadores')

<link rel="stylesheet" href="/static/css/ranking.css">

<div class="ranking-container">
    <h1>🏆 Hall da Fama</h1>
    <p>Os melhores enxadristas do servidor.</p>

    <table class="tabela-ranking">
        <thead>
            <tr>
                <th width="15%">Pos</th>
                <th width="60%" style="text-align: left; padding-left: 30px;">Jogador</th>
                <th width="25%">Pontuação</th>
            </tr>
        </thead>
        <tbody>
            % for i, player in enumerate(players):
                % pos = i + 1
                % css_class = f"pos-{pos}" if pos <= 3 else ""
                
                <tr class="{{css_class}}">
                    <td>
                        % if pos == 1:
                            <i class="fas fa-crown medalha"></i> 1º
                        % elif pos == 2:
                            <i class="fas fa-medal medalha"></i> 2º
                        % elif pos == 3:
                            <i class="fas fa-medal medalha"></i> 3º
                        % else:
                            {{pos}}º
                        % end
                    </td>
                    <td style="text-align: left; padding-left: 30px; display: flex; align-items: center;">
                        <div class="avatar">{{player['name'][0].upper()}}</div>
                        {{player['name']}}
                    </td>
                    <td><strong>{{player['score']}} pts</strong></td>
                </tr>
            % end
            
            % if not players:
                <tr>
                    <td colspan="3" style="padding: 30px; color: #777;">
                        Nenhum jogador cadastrado ainda. <br>
                        <a href="/users/add">Cadastre o primeiro!</a>
                    </td>
                </tr>
            % end
        </tbody>
    </table>

    <a href="/menu" class="btn-voltar">
        <i class="fas fa-home"></i> Voltar ao Menu
    </a>
</div>