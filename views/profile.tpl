% rebase('layout.tpl', title='Perfil do Jogador')

<link rel="stylesheet" href="/static/css/profile.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .btn-secondary {
        background-color: #7f8c8d; /* Cinza */
        color: white !important; /* Força o texto branco */
        border: none;
        border-radius: 8px;
        padding: 12px 25px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        display: flex; /* Garante alinhamento ícone-texto */
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        
        width: 100%; 
        box-sizing: border-box; 
        margin-top: 10px;
    }

    .btn-secondary:hover {
        background-color: #616e6e;
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.15);
    }
</style>

<div class="profile-container">
    
    <aside class="profile-card">
        <div style="font-size: 3rem; color: #ddd; margin-bottom: 10px;">
            <i class="fas fa-user-circle"></i>
        </div>
        
        <h1 class="profile-name">{{user.name}}</h1>
        <p class="profile-id">ID: #{{user.id}}</p>
        
        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

        <a href="/users" class="btn-primary" style="width: 100%; margin-bottom: 10px; box-sizing: border-box;">
            <i class="fas fa-list"></i> Voltar para Lista
        </a>

        <a href="/menu" class="btn-secondary">
            <i class="fas fa-home"></i> Menu Principal
        </a>
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
                    <button type="submit" class="btn-primary" style="width: auto; padding: 12px 30px;">
                        <i class="fas fa-save"></i> Salvar Alterações
                    </button>
                </div>
            </form>
        </div>

        <div class="content-box">
            <h2 class="box-title"><i class="fas fa-chess-board"></i> Histórico de Partidas</h2>

            % if defined('games') and games:
                <div class="table-container">
                    <table class="styled-table" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background-color: #f8f9fa; text-align: left;">
                                <th style="padding: 10px;">Jogo</th>
                                <th style="padding: 10px;">Oponente</th>
                                <th style="padding: 10px;">Cor</th>
                                <th style="padding: 10px;">Status</th>
                                <th style="padding: 10px;">Resultado</th>
                            </tr>
                        </thead>
                        <tbody>
                            % for game in games:
                                % is_p1 = (str(game.player1) == str(user.id))
                                % opponent = game.player2 if is_p1 else game.player1
                                % my_color = "Brancas" if is_p1 else "Pretas"
                                
                                <tr style="border-bottom: 1px solid #eee;">
                                    <td style="padding: 10px;"><strong>#{{game.id}}</strong></td>
                                    <td style="padding: 10px;">Vs. {{opponent}}</td>
                                    <td style="padding: 10px;">{{my_color}}</td>
                                    
                                    <td style="padding: 10px;">
                                        % if game.status == 'active':
                                            <span class="badge badge-active">Em Andamento</span>
                                        % else:
                                            <span class="badge badge-finished">Finalizado</span>
                                        % end
                                    </td>

                                    <td style="padding: 10px;">
                                        % if game.winner:
                                            % if str(game.winner) == str(user.id):
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
            % else:
                <div style="text-align: center; color: #999; padding: 30px;">
                    <i class="fas fa-chess-pawn" style="font-size: 40px; margin-bottom: 15px; display: block; color: #ddd;"></i>
                    Este usuário ainda não jogou nenhuma partida.
                </div>
            % end
        </div>

    </main>
</div>