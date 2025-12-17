# ♟️ Xadrez Real - Projeto Final de POO

Este projeto é uma aplicação web completa de **Xadrez**, desenvolvida como trabalho final da disciplina de **Programação Orientada a Objetos (POO)**.

O sistema foi construído sobre o template educacional do **Prof. Lucas Boaventura** (UnB), utilizando o microframework **Bottle** e a linguagem **Python**.

## 💡 Funcionalidades

O projeto vai além de um tabuleiro simples, integrando lógica de xadrez com persistência de dados e interface rica:

* **⚔️ Modos de Jogo:**
    * **Casual:** Jogue livremente sem login.
    * **Rankeado:** Requer login (ID) dos jogadores e vale pontos no ranking.
* **🏆 Sistema de Ranking:** Tabela de classificação dinâmica. Vitórias somam **+3 pontos**, derrotas subtraem **-3 pontos**.
* **🧠 Lógica Completa de Xadrez:**
    * Validação de movimentos (Peão, Torre, Cavalo, Bispo, Rainha, Rei).
    * Detecção de **Xeque** e **Xeque-Mate**.
    * Detecção de Empates (**Afogamento** e Material Insuficiente).
* **🎨 Interface Profissional:**
    * Peças em **SVG** de alta qualidade.
    * Indicadores visuais de última jogada e seleção.
    * Design responsivo estilo "Dashboard".
* **🔊 Efeitos Sonoros:** Feedback auditivo para movimentos, capturas, xeque e fim de jogo.
* **👥 Gestão de Usuários:** Cadastro, edição e exclusão de jogadores (CRUD completo).

---

## 🗂 Estrutura do Projeto

A arquitetura segue o padrão **MVC (Model-View-Controller)**:

```bash
xadrez-poo-bottle/
├── app.py              # Configuração das rotas e apps do Bottle
├── main.py             # Ponto de entrada (Roda o servidor)
├── config.py           # Configurações globais
├── seed.py             # Instancia objetos de teste no banco de dados
├── requirements.txt    # Dependências (bottle, etc...)
│
├── controllers/        # A "Cola" do sistema
│   ├── base_controller.py  # Utilitários comuns
│   ├── game_controller.py  # Lógica do Jogo, Ranking e Navegação
│   └── user_controller.py  # CRUD de Usuários
│
├── models/             # Regras de Negócio e Entidades
│   ├── Game.py             # Motor do Xadrez (Regras, Turnos, Mate)
│   ├── piece.py            # Classes das Peças (Herança e Polimorfismo)
│   ├── board_initialize.py # Matriz do Tabuleiro
│   ├── user.py             # Classe Usuário (+ Score)
│   └── ... (pawn.py, king.py, etc)
│
├── services/           # Persistência de Dados
│   ├── user_service.py     # Salva usuários e atualiza pontuação no Banco de Dados
│   └── game_service.py     # Salva e atualiza jogos no Banco de Dados
│
├── views/              # Front-end (HTML + Bottle Templates)
│   ├── layout.tpl          # Base HTML (Cabeçalho/Rodapé)
│   ├── menu.tpl            # Menu Principal (Cartão Centralizado)
│   ├── tabuleiro.tpl       # O Jogo (Dashboard, JS e Lógica AJAX)
│   ├── ranking.tpl         # Tabela de Classificação
│   ├── setup.tpl           # Configuração da Partida
│   └── ... (user views)
│
├── static/             # Arquivos Estáticos
│   ├── css/                # Estilos separados (game.css, menu.css, etc...)
│   ├── img/pieces/         # SVGs das peças (Cburnett style)
│   └── audio/              # Efeitos sonoros (move, capture, check, mate)
│
└── data/               # Banco de Dados
    └── chess_system.db         # Persistência dos jogadores e pontuação
```
## ▶️ Como Executar
Siga os passos abaixo para rodar o projeto na sua máquina:

1. Preparar o Ambiente
Certifique-se de ter o Python instalado. Abra o terminal na pasta do projeto:

Bash

# Cria o ambiente virtual (Recomendado)
python -m venv venv

# Ativa o ambiente
# Windows:
```
venv\Scripts\activate
```
# Linux/Mac:
```
source venv/bin/activate
```
2. Instalar Dependências
Bash
```
pip install -r requirements.txt
```
5. Adicionar instâncias teste
Bash
```
python seed.py
```
5. Rodar o Servidor
Bash
```
python main.py
```
6. Jogar
Abra seu navegador e acesse: http://localhost:8080

🎮 Guia Rápido de Uso
Cadastro: No menu principal, vá em "Jogadores" -> "Novo Jogador" para criar seu perfil. Anote seu ID.

Ranking: Cadastre um segundo jogador para ter um oponente.

Partida: Volte ao Menu, clique em "Iniciar Jogo", selecione "Modo Rankeado" e insira os IDs das Brancas e das Pretas.

Vitória: Ao dar Xeque-Mate, a pontuação será atualizada automaticamente no Ranking.

🧠 Autores
Projeto desenvolvido pelo trio:

[Daniel Filipe](https://github.com/daniel-fbo) - Front-end, Controllers e Integração.

[Eduardo Dal Pizol](https://github.com/Edupizzol) - Back-end (Motor de Xadrez e Lógica das Peças).

[João Pedro da Nóbrega](https://github.com/nbg-cordeiro) - Services e Persistência de Dados.

📄 Licença
Projeto desenvolvido como template didático baseado no BMVC. Livre para uso educacional e modificações.
