% rebase('layout', title='Perfil do Jogador')

<!-- Link para o CSS específico desta página -->
<link rel="stylesheet" href="/static/css/profile.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<a href="/" class="btn-home">
    <i class="fas fa-home"></i> Página Inicial
</a>

<div class="profile-container">

    <!-- COLUNA DA ESQUERDA: IDENTIDADE -->
    <aside class="profile-card">
        <h1 class="profile-name">{{user.name}}</h1>
        <p class="profile-id">ID: #{{user.id}}</p>
        
        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

        <!-- Botão Voltar -->
        <a href="/users" class="btn-primary" style="width: 100%;">
            <i class="fas fa-arrow-left"></i> Voltar para Lista
        </a>
    </aside>

    <!-- COLUNA DA DIREITA: CONTEÚDO -->
    <main class="main-content">
        
        <!-- CAIXA 1: EDITAR DADOS -->
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

                <div style="text-align: right; margin-top: 10px;">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Salvar Alterações
                    </button>
                </div>
            </form>
        </div>

        <!-- CAIXA 2: HISTÓRICO DE JOGOS -->
        <div class="content-box">
            <h2 class="box-title"><i class="fas fa-chess-board"></i> Histórico de Partidas</h2>

            % if not games:
                <div style="text-align: center; color: #888; padding: 20px;">
                    <i class="fas fa-chess-pawn" style="font-size: 30px; margin-bottom: 10px; display: block;"></i>
                    Este usuário ainda não jogou nenhuma partida.
                </div>
            % else:
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
                                        % if game.winner == user.id:
                                            <span class="badge badge-win"><i class="fas fa-trophy"></i> Vitória</span>
                                        % else:
                                            <span class="badge badge-loss"><i class="fas fa-times"></i> Derrota</span>
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
            % end
        </div>

    </main>
</div>