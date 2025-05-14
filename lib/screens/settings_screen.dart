import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nameController = TextEditingController(text: userProvider.name);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Your Name'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              userProvider.setName(nameController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
