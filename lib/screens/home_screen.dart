import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: ListView(
        children: todoProvider.todos
            .map((todo) => TodoTile(
                  todo: todo,
                  onToggleComplete: () => todoProvider.toggleComplete(todo.id),
                  onRemove: () => todoProvider.removeTodo(todo.id),
                  onToggleSticky: () => todoProvider.toggleSticky(todo.id),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description')),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 2),
                );
              },
              child: const Text("Pick Due Date"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedDate != null) {
                final todo = Todo(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text,
                  dueDate: selectedDate!,
                );
                Provider.of<TodoProvider>(context, listen: false).addTodo(todo);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
