class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String priority;
  final bool done;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    required this.done,
    required this.createdAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'] ?? 'media',
      done: map['done'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'done': done,
    };
  }

  Task copyWith({
    String? title,
    String? description,
    String? priority,
    bool? done,
  }) {
    return Task(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      done: done ?? this.done,
      createdAt: createdAt,
    );
  }
}
