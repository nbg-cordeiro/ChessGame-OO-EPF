% rebase('layout.tpl', title='Perfil do Jogador')

<link rel="stylesheet" href="/static/css/user_form.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="profile-wrapper">
    <div class="profile-container">
        
        <aside class="profile-card">
            
            <div class="avatar-large">
                <i class="fas fa-user-circle" style="font-size: 80px; color: #bdc3c7; line-height: 1;"></i>
            </div>
            
            % if user:
                <h1 class="profile-name">{{user.name}}</h1>
                
                <div style="display: flex; flex-direction: column; align-items: center; width: 100%;">
                    
                    <span class="info-pill pill-id">
                        ID: #{{user.id}}
                    </span>
                    
                    <span class="info-pill pill-score">
                        <i class="fas fa-trophy"></i> {{getattr(user, 'score', 0)}} pts
                    </span>
                </div>

            % else:
                <h1 class="profile-name">Novo Jogador</h1>
                <span class="info-pill pill-id">Cadastro</span>
            % end
            
            <hr style="border: 0; border-top: 1px solid #eee; margin: 25px 0; width: 100%;">

            <div style="display: flex; flex-direction: column; gap: 10px; width: 100%;">
                <a href="/users" class="btn btn-info" style="justify-content: center;">
                    <i class="fas fa-list"></i> Voltar para Lista
                </a>

                <a href="/menu" class="btn btn-secondary" style="justify-content: center;">
                    <i class="fas fa-home"></i> Menu Principal
                </a>
            </div>
        </aside>

        <main class="main-content">
            
            <div class="content-box">
                <h2 class="box-title"><i class="fas fa-user-edit"></i> Editar Informações</h2>
                
                <form action="{{action}}" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Nome Completo</label>
                            <input type="text" name="name" value="{{user.name if user else ''}}" required>
                        </div>

                        <div class="form-group">
                            <label>Data de Nascimento</label>
                            <input type="date" name="birthdate" value="{{user.birthdate if user else ''}}" required>
                        </div>

                        <div class="form-group full-width">
                            <label>Email</label>
                            <input type="email" name="email" value="{{user.email if user else ''}}" required>
                        </div>
                    </div>

                    <div style="text-align: right; margin-top: 25px;">
                        <button type="submit" class="btn btn-primary" style="width: auto; padding-left: 40px; padding-right: 40px;">
                            <i class="fas fa-save"></i> Salvar Alterações
                        </button>
                    </div>
                </form>
            </div>

            % if user:
                <div class="content-box">
                    <h2 class="box-title"><i class="fas fa-chess-board"></i> Histórico de Partidas</h2>

                    % if defined('games') and games:
                        <div class="table-responsive">
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
                            <i class="fas fa-ghost" style="font-size: 30px; margin-bottom: 15px; display: block; opacity: 0.3;"></i>
                            Este usuário ainda não jogou nenhuma partida.
                        </div>
                    % end
                </div>
            % end

        </main>
    </div>
</div>