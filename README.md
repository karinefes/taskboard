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

## Como executar

1. Instale o Flutter: https://flutter.dev/docs/get-started/install
2. Clone ou abra o projeto no Android Studio
3. Rode `flutter pub get` no terminal
4. Execute com `flutter run`

## Configuração do Supabase

A URL e a Anon Key já estão configuradas em `lib/main.dart`.

### SQL para criar a tabela (rode no SQL Editor do Supabase):

```sql
create table tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  description text,
  priority text default 'media',
  done boolean default false,
  created_at timestamptz default now()
);

alter table tasks enable row level security;

create policy "Users manage own tasks"
  on tasks for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
```

### Desativar confirmação de e-mail (para desenvolvimento):

Supabase → Authentication → Providers → Email → desative "Confirm email"

## Autenticação

Utiliza Supabase Auth com e-mail e senha. As rotas são protegidas verificando
`supabase.auth.currentSession` no `main.dart`. Somente usuários autenticados
conseguem acessar a `HomeScreen`.
