% rebase('layout', title='Usuários')

<!-- Link para o CSS Externo -->
<link rel="stylesheet" href="/static/css/users.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<a href="/" class="btn-home">
    <i class="fas fa-home"></i> Página Inicial
</a>

<section class="users-section">
    <div class="section-header">
        <h1 class="section-title"><i class="fas fa-users"></i> Gestão de Usuários</h1>
        <a href="/users/add" class="btn btn-primary">
            <i class="fas fa-plus"></i> Novo Usuário
        </a>
    </div>

    <div class="table-container">
        <table class="styled-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Data Nasc.</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                % for u in users:
                <tr>
                    <td>{{u.id}}</td>
                    <td>{{u.name}}</td>
                    <td><a href="mailto:{{u.email}}">{{u.email}}</a></td>
                    <td>{{u.birthdate}}</td>
                    
                    <td class="actions">
                        <a href="/profile/{{u.id}}" class="btn btn-sm btn-info">
                            <i class="fas fa-user-circle"></i> Perfil
                        </a>
                    </td>
                </tr>
                % end
            </tbody>
        </table>
    </div>
</section>