# TaskBoard

Sistema de gerenciamento de tarefas desenvolvido com Flutter e Supabase.

## Funcionalidades

- ✅ Cadastro e login de usuários (Supabase Auth)
- ✅ CRUD completo de tarefas (criar, listar, editar, excluir)
- ✅ Prioridades: Alta, Média e Baixa
- ✅ Marcar tarefas como concluídas
- ✅ Filtros por status e prioridade
- ✅ Proteção de rotas (apenas usuários autenticados acessam o home)
- ✅ Validação de formulários
- ✅ Row Level Security (cada usuário vê apenas suas tarefas)

## Tecnologias

- Flutter 3.x / Dart 3.x
- Supabase (Auth + PostgreSQL)
- Material Design 3

## Estrutura do projeto

```
lib/
├── main.dart
├── models/
│   └── task.dart
├── screens/
│   ├── login_screen.dart
│   └── home_screen.dart
├── services/
│   ├── auth_service.dart
│   └── database_service.dart
└── widgets/
    ├── task_card.dart
    └── task_form_dialog.dart
```