import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../screens/login_screen.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _dbService = DatabaseService();

  List<Task> _tasks = [];
  bool _loading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    try {
      final tasks = await _dbService.getTasks();
      setState(() => _tasks = tasks);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<void> _toggleDone(Task task) async {
    await _dbService.toggleDone(task.id, !task.done);
    await _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _dbService.deleteTask(task.id);
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa excluída.')),
        );
      }
    }
  }

  Future<void> _openForm({Task? task}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => TaskFormDialog(task: task, dbService: _dbService),
    );
    if (result == true) await _loadTasks();
  }

  List<Task> get _filteredTasks {
    switch (_filter) {
      case 'pending': return _tasks.where((t) => !t.done).toList();
      case 'done': return _tasks.where((t) => t.done).toList();
      case 'alta': return _tasks.where((t) => t.priority == 'alta').toList();
      case 'media': return _tasks.where((t) => t.priority == 'media').toList();
      case 'baixa': return _tasks.where((t) => t.priority == 'baixa').toList();
      default: return _tasks;
    }
  }

  int get _pendingCount => _tasks.where((t) => !t.done).length;
  int get _doneCount => _tasks.where((t) => t.done).length;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final email = _authService.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.checklist_rounded),
            SizedBox(width: 8),
            Text('TaskBoard'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              child: Chip(
                avatar: const Icon(Icons.person_outline, size: 16),
                label: Text(email.split('@').first,
                    style: const TextStyle(fontSize: 12)),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: _logout,
                  child: const Row(
                    children: [
                      Icon(Icons.logout, size: 18),
                      SizedBox(width: 8),
                      Text('Sair'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatCard(label: 'Total', value: _tasks.length, color: scheme.primary),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Pendentes', value: _pendingCount, color: Colors.orange),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Concluídas', value: _doneCount, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(label: 'Todas', value: 'all', current: _filter, onTap: (v) => setState(() => _filter = v)),
                          _FilterChip(label: 'Pendentes', value: 'pending', current: _filter, onTap: (v) => setState(() => _filter = v)),
                          _FilterChip(label: 'Concluídas', value: 'done', current: _filter, onTap: (v) => setState(() => _filter = v)),
                          _FilterChip(label: '🔴 Alta', value: 'alta', current: _filter, onTap: (v) => setState(() => _filter = v)),
                          _FilterChip(label: '🟡 Média', value: 'media', current: _filter, onTap: (v) => setState(() => _filter = v)),
                          _FilterChip(label: '🟢 Baixa', value: 'baixa', current: _filter, onTap: (v) => setState(() => _filter = v)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredTasks.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined, size: 56, color: scheme.onSurfaceVariant),
                      const SizedBox(height: 12),
                      Text('Nenhuma tarefa encontrada',
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TaskCard(
                      task: _filteredTasks[i],
                      onToggle: () => _toggleDone(_filteredTasks[i]),
                      onEdit: () => _openForm(task: _filteredTasks[i]),
                      onDelete: () => _deleteTask(_filteredTasks[i]),
                    ),
                  ),
                  childCount: _filteredTasks.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text('$value',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final void Function(String) onTap;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(value),
      ),
    );
  }
}
