% rebase('layout.tpl', title='Perfil do Jogador')

<link rel="stylesheet" href="/static/css/user_form.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* 1. CORREÇÃO DO AVATAR: Centraliza o círculo na tela */
    .avatar-large {
        width: 120px;
        height: 120px;
        background-color: #ecf0f1;
        border-radius: 50%;
        
        /* O SEGREDO: Margem automática nas laterais centraliza o bloco */
        margin: 0 auto 20px auto; 
        
        /* Centraliza o ícone dentro do círculo */
        display: flex;
        justify-content: center;
        align-items: center;
        
        border: 4px solid white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    /* 2. CORREÇÃO DOS BOTÕES: Força o estilo visual */
    .btn-custom {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        width: 100%;
        padding: 12px;
        border-radius: 8px;
        font-weight: 600;
        text-decoration: none;
        box-sizing: border-box; /* Garante que não estoure a largura */
        margin-bottom: 10px;
        transition: transform 0.2s;
        border: none;
        font-size: 1rem;
        cursor: pointer;
    }
    
    .btn-custom:hover { transform: translateY(-2px); }

    /* Cores dos Botões */
    .btn-verde { background-color: #009688; color: white !important; }
    .btn-verde:hover { background-color: #00796b; }

    .btn-cinza { background-color: #7f8c8d; color: white !important; }
    .btn-cinza:hover { background-color: #616e6e; }
</style>

<div class="profile-wrapper">
    <div class="profile-container">
        
        <aside class="profile-card">
            
            <div class="avatar-large">
                <i class="fas fa-user-circle" style="font-size: 80px; color: #bdc3c7; line-height: 1;"></i>
            </div>
            
            % if user:
                <h1 class="profile-name">{{user.name}}</h1>
                <span class="profile-id">ID: #{{user.id}}</span>
            % else:
                <h1 class="profile-name">Novo Jogador</h1>
                <span class="profile-id">Cadastro</span>
            % end
            
            <hr style="border: 0; border-top: 1px solid #eee; margin: 25px 0; width: 100%;">

            <a href="/users" class="btn-custom btn-verde">
                <i class="fas fa-list"></i> Voltar para Lista
            </a>

            <a href="/menu" class="btn-custom btn-cinza">
                <i class="fas fa-home"></i> Menu Principal
            </a>
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
                        <button type="submit" class="btn-custom btn-verde" style="width: auto; padding-left: 30px; padding-right: 30px;">
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
                                                    <span class="badge badge-active" style="background:#cce5ff; color:#004085; padding:4px 8px; border-radius:4px; font-size:0.8em;">Em Andamento</span>
                                                % else:
                                                    <span class="badge badge-finished" style="background:#e2e3e5; color:#383d41; padding:4px 8px; border-radius:4px; font-size:0.8em;">Finalizado</span>
                                                % end
                                            </td>
                                            <td style="padding: 10px;">
                                                % if game.winner:
                                                    % if str(game.winner) == str(user.id):
                                                        <span style="color: green; font-weight: bold;">Vitória</span>
                                                    % else:
                                                        <span style="color: red; font-weight: bold;">Derrota</span>
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
                            <i class="fas fa-ghost" style="font-size: 30px; margin-bottom: 10px; display: block; opacity: 0.3;"></i>
                            Este usuário ainda não jogou nenhuma partida.
                        </div>
                    % end
                </div>
            % end

        </main>
    </div>
</div>