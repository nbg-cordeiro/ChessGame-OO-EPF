<link rel="stylesheet" href="/static/css/user_form.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="container"> 
    
    <div class="form-card">
        <div class="form-header">
            <h1 class="form-title">
                <i class="fas fa-user-edit"></i> 
                {{'Editar Usuário' if user else 'Novo Usuário'}}
            </h1>
            <p class="form-subtitle">Preencha os dados abaixo para salvar</p>
        </div>
        
        <form action="{{action}}" method="post">
            
            <div class="form-grid">
                
                <div class="form-group">
                    <label for="name">Nome Completo</label>
                    <input type="text" id="name" name="name" required 
                           value="{{user.name if user else ''}}"
                           placeholder="Ex: João Silva">
                </div>

                <div class="form-group">
                    <label for="birthdate">Data de Nascimento</label>
                    <input type="date" id="birthdate" name="birthdate" required 
                           value="{{user.birthdate if user else ''}}">
                </div>

                <div class="form-group full-width">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required 
                           value="{{user.email if user else ''}}"
                           placeholder="Ex: joao@email.com">
                </div>
            
            </div>
            
            <div class="form-actions">
                <a href="/menu" class="btn btn-cancel">
                    <i class="fas fa-home"></i> Menu Principal
                </a>

                <button type="submit" class="btn btn-save">
                    <i class="fas fa-save"></i> Salvar
                </button>
            </div>

        </form>
    </div>
</div>