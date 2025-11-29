% rebase('layout.tpl', title='Perfil do Jogador')

<link rel="stylesheet" href="/static/css/profile.css">

<div class="profile-wrapper">
    <div class="profile-container">
        
        <aside class="profile-card">
            <div class="avatar-large">
                <i class="fas fa-user-circle"></i>
            </div>
            
            <h1 class="profile-name">{{user.name}}</h1>
            <span class="profile-id">ID: #{{user.id}}</span>
            
            <hr style="border: 0; border-top: 1px solid #eee; margin: 25px 0;">

            <div style="display: flex; flex-direction: column; gap: 10px;">
                <a href="/users" class="btn btn-info">
                    <i class="fas fa-list"></i> Voltar para Lista
                </a>

                <a href="/menu" class="btn btn-secondary">
                    <i class="fas fa-home"></i> Menu Principal
                </a>
            </div>
        </aside>

        <main class="main-content">
            
            <div class="content-box">
                <h2 class="box-title"><i class="fas fa-user-edit"></i> Editar Informações</h2>
                
                <form action="/users/edit/{{user.id}}" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Nome Completo</label>
                            <input type="text" name="name" value="{{user.name}}" required>
                        </div>

                        <div class="form-group">
                            <label>Data de Nascimento</label>
                            <input type="date" name="birthdate" value="{{user.birthdate}}" required>
                        </div>

                        <div class="form-group full-width">
                            <label>Email</label>
                            <input type="email" name="email" value="{{user.email}}" required>
                        </div>
                    </div>

                    <div style="text-align: right; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary" style="width: auto; padding-left: 40px; padding-right: 40px;">
                            <i class="fas fa-save"></i> Salvar Alterações
                        </button>
                    </div>
                </form>
            </div>

            <div class="content-box">
                <h2 class="box-title"><i class="fas fa-chess-board"></i> Histórico de Partidas</h2>

                % if defined('games') and games:
                    <div class="table-container">
                        <table class="styled-table">
                            <thead>
                                <tr>
                                    <th>Jogo</th>
                                    <th>Oponente</th>
                                    <th>Cor</th>
                                    <th>Status</th>
                                    <th>Resultado</th>
                                </tr>
                            </thead>
                            <tbody>
                                % for game in games:
                                    % is_p1 = (str(game.player1) == str(user.id))
                                    % opponent = game.player2 if is_p1 else game.player1
                                    % my_color = "Brancas" if is_p1 else "Pretas"
                                    
                                    <tr>
                                        <td><strong>#{{game.id}}</strong></td>
                                        <td>Vs. {{opponent}}</td>
                                        <td>{{my_color}}</td>
                                        <td>
                                            % if game.status == 'active':
                                                <span class="badge badge-active">Em Andamento</span>
                                            % else:
                                                <span class="badge badge-finished">Finalizado</span>
                                            % end
                                        </td>
                                        <td>
                                            % if game.winner:
                                                % if str(game.winner) == str(user.id):
                                                    <span class="badge badge-win">Vitória</span>
                                                % else:
                                                    <span class="badge badge-loss">Derrota</span>
                                                % end
                                            % else:
                                                -
                                            % end
                                        </td>
                                    </tr>
                                % end
                            </tbody>
                        </table>
                    </div>
                % else:
                    <div style="text-align: center; color: #999; padding: 40px;">
                        <i class="fas fa-ghost" style="font-size: 40px; margin-bottom: 15px; display: block; opacity: 0.3;"></i>
                        Este usuário ainda não jogou nenhuma partida.
                    </div>
                % end
            </div>

        </main>
    </div>
</div>