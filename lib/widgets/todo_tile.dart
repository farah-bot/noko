import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggleComplete;
  final VoidCallback onRemove;
  final VoidCallback onToggleSticky;

  const TodoTile({
    required this.todo,
    required this.onToggleComplete,
    required this.onRemove,
    required this.onToggleSticky,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo.isSticky ? Colors.amber[100] : Colors.white,
      elevation: 3,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggleComplete(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(todo.dueDate)),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'delete') onRemove();
            if (value == 'sticky') onToggleSticky();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'sticky', child: Text("Toggle Sticky")),
            const PopupMenuItem(value: 'delete', child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}
