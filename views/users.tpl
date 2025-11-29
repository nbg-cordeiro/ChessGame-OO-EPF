% rebase('layout.tpl', title='Lista de Jogadores')

<link rel="stylesheet" href="/static/css/users.css">

<div class="users-wrapper">
    <div class="users-card">
        
        <div class="section-header">
            <h1 class="section-title">
                <i class="fas fa-users"></i> Gestão de Jogadores
            </h1>
            <a href="/users/add" class="btn btn-primary btn-lg-mobile">
                <i class="fas fa-plus"></i> Novo Jogador
            </a>
        </div>

        <div class="table-responsive">
            <table class="styled-table">
                <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="25%">Nome</th>
                        <th width="30%">Email</th>
                        <th width="15%">Nascimento</th>
                        <th width="25%">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    % for u in users:
                    <tr>
                        <td><strong>#{{u.id}}</strong></td>
                        <td>{{u.name}}</td>
                        <td><a href="mailto:{{u.email}}" class="email-link">{{u.email}}</a></td>
                        <td>{{u.birthdate}}</td>
                        
                        <td class="actions">
                            <a href="/profile/{{u.id}}" class="btn btn-info btn-sm">
                                <i class="fas fa-user-circle"></i> Perfil
                            </a>

                            <form action="/users/delete/{{u.id}}" method="post" onsubmit="return confirm('Tem certeza que deseja excluir este jogador?');" style="display:inline;">
                                <button type="submit" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    % end
                    
                    % if not users:
                    <tr>
                        <td colspan="5" class="empty-state">
                            <i class="fas fa-folder-open"></i>
                            Nenhum jogador encontrado.
                        </td>
                    </tr>
                    % end
                </tbody>
            </table>
        </div>

        <div style="margin-top: 30px;">
            <a href="/menu" class="btn btn-secondary" style="width: auto; display: inline-flex; padding-left: 30px; padding-right: 30px;">
                <i class="fas fa-arrow-left"></i> Voltar ao Menu
            </a>
        </div>

    </div>
</div>