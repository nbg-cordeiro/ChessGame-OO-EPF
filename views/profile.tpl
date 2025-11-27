<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil de {{user.name}}</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f9; color: #333; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        
        /* Cabeçalho do Perfil */
        .header { border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .header h1 { margin: 0; color: #2c3e50; }
        
        /* Formulário */
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
        .info-static { background: #e9ecef; padding: 10px; border-radius: 4px; color: #555; }
        
        .btn-save { background-color: #28a745; color: white; border: none; padding: 10px 20px; font-size: 16px; cursor: pointer; border-radius: 4px; margin-top: 10px; }
        .btn-save:hover { background-color: #218838; }

        /* Tabela de Jogos */
        h2 { border-left: 5px solid #007bff; padding-left: 10px; margin-top: 40px; color: #007bff; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        tr:hover { background-color: #f1f1f1; }
        
        .status-active { color: #e67e22; font-weight: bold; }
        .status-finished { color: #28a745; font-weight: bold; }
        .win-badge { background-color: gold; padding: 2px 6px; border-radius: 4px; font-size: 0.8em; color: #333; margin-left: 5px; }

        .btn-back { display: inline-block; margin-top: 30px; color: #666; text-decoration: none; border: 1px solid #ccc; padding: 8px 16px; border-radius: 4px; }
        .btn-back:hover { background-color: #eee; }
    </style>
</head>
<body>

<div class="container">
    
    <div class="header">
        <h1>Perfil do Jogador</h1>
    </div>

    <form action="/profile/{{user.id}}" method="POST">
        
        <div class="form-group">
            <label for="name">Nome de Exibição:</label>
            <input type="text" id="name" name="name" value="{{user.name}}" required>
        </div>

        <div class="form-group">
            <label>Email (Não editável):</label>
            <div class="info-static">{{user.email}}</div>
        </div>

        <div class="form-group">
            <label>ID do Jogador:</label>
            <div class="info-static">#{{user.id}}</div>
        </div>

        <input type="hidden" name="email" value="{{user.email}}">
        <input type="hidden" name="birthdate" value="{{user.birthdate}}">

        <button type="submit" class="btn-save">Salvar Alterações</button>
    </form>


    <h2>Histórico de Partidas</h2>

    % if not games:
        <p style="color: #777; font-style: italic;">Este jogador ainda não participou de nenhuma partida.</p>
    % else:
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Oponente</th>
                    <th>Você jogou de</th>
                    <th>Status</th>
                    <th>Vencedor</th>
                </tr>
            </thead>
            <tbody>
            % for game in games:
                % is_p1 = (str(game.player1) == str(user.name))
                % opponent = game.player2 if is_p1 else game.player1
                % my_color = "Brancas" if is_p1 else "Pretas"
                
                <tr>
                    <td><strong>#{{game.id}}</strong></td>
                    <td>Vs. {{opponent}}</td>
                    <td>{{my_color}}</td>
                    
                    <td>
                        % if game.status == 'active':
                            <span class="status-active">Em Andamento</span>
                        % else:
                            <span class="status-finished">Finalizado</span>
                        % end
                    </td>

                    <td>
                        % if game.winner:
                            {{game.winner}}
                            % if game.winner == user.name:
                                <span class="win-badge">VITÓRIA</span>
                            % end
                        % else:
                            -
                        % end
                    </td>
                </tr>
            % end
            </tbody>
        </table>
    % end

    <a href="/users" class="btn-back">← Voltar para Lista de Usuários</a>
</div>

</body>
</html>