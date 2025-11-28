% rebase('layout', title='Formulário de Usuário')

<!-- Links CSS -->
<link rel="stylesheet" href="/static/css/user_form.css">
<link rel="stylesheet" href="/static/css/botaohome.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Botão Home Fixo -->
<a href="/" class="btn-home">
    <i class="fas fa-home"></i> Página Inicial
</a>

<div class="form-card">
    <div class="form-header">
        <h1 class="form-title">
            <i class="fas fa-user-edit"></i> 
            {{'Editar Usuário' if user else 'Novo Usuário'}}
        </h1>
        <p class="form-subtitle">Preencha os dados abaixo para salvar</p>
    </div>
    
    <form action="{{action}}" method="post">
        
        <!-- Grid para organizar os campos -->
        <div class="form-grid">
            
            <!-- Campo Nome -->
            <div class="form-group">
                <label for="name">Nome Completo</label>
                <input type="text" id="name" name="name" required 
                       value="{{user.name if user else ''}}"
                       placeholder="Ex: João Silva">
            </div>

            <!-- Campo Data de Nascimento -->
            <div class="form-group">
                <label for="birthdate">Data de Nascimento</label>
                <input type="date" id="birthdate" name="birthdate" required 
                       value="{{user.birthdate if user else ''}}">
            </div>

            <!-- Campo Email (Ocupa largura total) -->
            <div class="form-group full-width">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required 
                       value="{{user.email if user else ''}}"
                       placeholder="Ex: joao@email.com">
            </div>
        
        </div>
        
        <div class="form-actions">
            <!-- Botão Voltar (Secundário) -->
            <a href="/users" class="btn btn-cancel">
                <i class="fas fa-arrow-left"></i> Cancelar
            </a>

            <!-- Botão Salvar (Primário) -->
            <button type="submit" class="btn btn-save">
                <i class="fas fa-save"></i> Salvar
            </button>
        </div>

    </form>
</div>