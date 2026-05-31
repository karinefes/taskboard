import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  Future<List<Task>> getTasks() async {
    final data = await _supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((e) => Task.fromMap(e)).toList();
  }

  Future<void> createTask({
    required String title,
    String? description,
    required String priority,
    DateTime? dueDate,
  }) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('tasks').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'priority': priority,
      'done': false,
      'due_date': dueDate?.toIso8601String(),
    });
  }

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    required String priority,
    DateTime? dueDate,
  }) async {
    await _supabase.from('tasks').update({
      'title': title,
      'description': description,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
    }).eq('id', id);
  }

  Future<void> toggleDone(String id, bool done) async {
    await _supabase.from('tasks').update({'done': done}).eq('id', id);
  }

  Future<void> deleteTask(String id) async {
    await _supabase.from('tasks').delete().eq('id', id);
  }
}