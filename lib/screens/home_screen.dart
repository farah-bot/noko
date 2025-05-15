import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello, ${userProvider.name}!',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: todoProvider.todos
                  .map((todo) => TodoTile(
                        todo: todo,
                        onToggleComplete: () =>
                            todoProvider.toggleComplete(todo.id),
                        onRemove: () => todoProvider.removeTodo(todo.id),
                        onToggleSticky: () =>
                            todoProvider.toggleSticky(todo.id),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 19, 57, 226),
        shape: const CircleBorder(),
        elevation: 6.0,
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
        backgroundColor: Colors.white,
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 19, 57, 226)),
                ),
              ),
              cursorColor: Color.fromARGB(255, 19, 57, 226),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 19, 57, 226)),
                ),
              ),
              cursorColor: Color.fromARGB(255, 19, 57, 226),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 2),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogBackgroundColor: Colors.white,
                        colorScheme: const ColorScheme.light(
                          primary: Color.fromARGB(255, 19, 57, 226),
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          timePickerTheme: const TimePickerThemeData(
                            backgroundColor: Colors.white,
                          ),
                          colorScheme: const ColorScheme.light(
                            primary: Color.fromARGB(255, 19, 57, 226),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    selectedDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 19, 57, 226),
                backgroundColor: Colors.white,
                elevation: 3,
                shadowColor: Colors.grey,
                side: const BorderSide(color: Color.fromARGB(255, 19, 57, 226)),
              ),
              child: const Text("Pick Due Date & Time"),
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
