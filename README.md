# TaskBoard 📋

Sistema de gerenciamento de tarefas desenvolvido com Flutter e Supabase, com autenticação de usuários e armazenamento em nuvem.

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Função |
|---|---|---|
| Flutter | 3.x | Framework principal (UI e lógica) |
| Dart | 3.x | Linguagem de programação |
| Supabase | 2.x | Backend: autenticação e banco de dados |
| PostgreSQL | — | Banco de dados (via Supabase) |
| Material Design | 3 | Sistema de design da interface |

---

## 📱 Telas do Projeto

### 1. Tela de Login / Cadastro (`login_screen.dart`)

Tela inicial do aplicativo, acessível sem autenticação.

**Funcionalidades:**
- Alternância entre as abas **Entrar** e **Cadastrar** via `TabBar`
- Campo de e-mail com validação de formato
- Campo de senha com opção de mostrar/ocultar
- Campo de confirmação de senha (apenas no cadastro)
- Feedback visual de carregamento durante a requisição
- Mensagens de erro traduzidas para português
- Redirecionamento automático para a tela principal após login

**Validações:**
- E-mail não pode estar vazio e deve conter `@`
- Senha deve ter no mínimo 6 caracteres
- Confirmação de senha deve ser idêntica à senha

---

### 2. Tela Principal (`home_screen.dart`)

Tela principal do app, acessível apenas para usuários autenticados.

**Funcionalidades:**
- Exibição do e-mail do usuário logado na barra superior
- Botão de logout no menu do usuário
- Cards de estatísticas: **Total**, **Pendentes** e **Concluídas**
- Filtros por status (`Todas`, `Pendentes`, `Concluídas`) e por prioridade (`Alta`, `Média`, `Baixa`)
- Lista de tarefas com scroll e pull-to-refresh (puxar para atualizar)
- Botão flutuante (**FAB**) para criar nova tarefa
- Estado vazio com ícone e mensagem quando não há tarefas
- Diálogo de confirmação antes de excluir uma tarefa

---

## 🧩 Widgets

### TaskCard (`task_card.dart`)

Card visual que representa cada tarefa na lista.

**Exibe:**
- Checkbox animado para marcar como concluída
- Título com riscado quando concluída
- Descrição (quando preenchida)
- Badge colorido de prioridade (🔴 Alta / 🟡 Média / 🟢 Baixa)
- Data de criação formatada
- Menu de ações (editar / excluir)

---

### TaskFormDialog (`task_form_dialog.dart`)

Modal (dialog) usado tanto para criar quanto para editar tarefas.

**Campos:**
- Título (obrigatório)
- Descrição (opcional)
- Prioridade (dropdown: Baixa / Média / Alta)

**Comportamento:**
- Quando aberto com uma tarefa existente, preenche os campos automaticamente
- Exibe indicador de carregamento ao salvar
- Fecha o modal e atualiza a lista após salvar com sucesso

---

## 🗂️ Estrutura do Projeto

```
lib/
├── main.dart                  # Inicialização do app e Supabase
├── models/
│   └── task.dart              # Modelo de dados da tarefa
├── screens/
│   ├── login_screen.dart      # Tela de login e cadastro
│   └── home_screen.dart       # Tela principal com lista de tarefas
├── services/
│   ├── auth_service.dart      # Login, cadastro e logout
│   └── database_service.dart  # CRUD de tarefas no Supabase
└── widgets/
    ├── task_card.dart         # Card visual de cada tarefa
    └── task_form_dialog.dart  # Modal de criar/editar tarefa
```

---

## 🔐 Autenticação

A autenticação é feita via **Supabase Auth** com e-mail e senha.

- O `main.dart` verifica se há uma sessão ativa ao iniciar o app
- Se houver sessão, redireciona para `HomeScreen`
- Se não houver, redireciona para `LoginScreen`
- O logout encerra a sessão e retorna para a tela de login
- As tarefas são protegidas por **Row Level Security (RLS)** no banco — cada usuário só acessa seus próprios dados

---

## 🚀 Como Executar

1. Instale o Flutter: https://flutter.dev/docs/get-started/install
2. Instale o Git: https://git-scm.com/download/win
3. Clone o repositório:
   ```
   git clone https://github.com/karinefes/taskboard.git
   ```
4. Entre na pasta do projeto:
   ```
   cd taskboard
   ```
5. Instale as dependências:
   ```
   flutter pub get
   ```
6. Execute o app:
   ```
   flutter run -d chrome
   ```

---

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.3.0
  google_fonts: ^6.1.0
  intl: ^0.19.0
```