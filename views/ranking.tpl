% rebase('layout.tpl', title='Ranking de Jogadores')

<style>
    .ranking-container {
        max-width: 800px;
        margin: 40px auto;
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        padding: 30px;
        text-align: center;
    }

    h1 { color: #2c3e50; font-size: 2.5em; margin-bottom: 20px; }
    
    .tabela-ranking {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    .tabela-ranking th {
        background-color: #2c3e50;
        color: white;
        padding: 15px;
        font-size: 1.1em;
    }

    .tabela-ranking td {
        padding: 15px;
        border-bottom: 1px solid #eee;
        font-size: 1.1em;
        color: #333;
    }

    /* Cores Especiais para o TOP 3 */
    .pos-1 { background-color: #fff9c4; font-weight: bold; } 
    .pos-1 .medalha { color: #f1c40f; } 
    .pos-2 { background-color: #f5f5f5; font-weight: bold; } 
    .pos-2 .medalha { color: #95a5a6; }
    .pos-3 { background-color: #ffe0b2; font-weight: bold; } 
    .pos-3 .medalha { color: #d35400; } 

    .avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #ddd;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-right: 10px;
        font-size: 0.8em;
        color: #555;
    }

    .btn-voltar {
        display: inline-block;
        margin-top: 30px;
        padding: 10px 25px;
        background-color: #7f8c8d;
        color: white;
        text-decoration: none;
        border-radius: 20px;
        transition: background 0.3s;
    }
    .btn-voltar:hover { background-color: #95a5a6; }
</style>

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
        <i class="fas fa-arrow-left"></i> Voltar ao Menu
    </a>
</div>