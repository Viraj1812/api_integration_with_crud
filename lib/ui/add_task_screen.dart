import 'dart:math';

import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ADD Task',
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Completed'),
                  Switch(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                String randomId = generateRandomId();
                if (titleController.text.isNotEmpty) {
                  TODO newTask = TODO(
                    id: randomId,
                    todoName: titleController.text,
                    isComplete: isCompleted,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    v: 0,
                  );
                  await RemoteService().addTodo(newTask);
                  _showToast(context, 'TODO Added Successfully!');
                  Navigator.pop(context, newTask);
                } else {
                  _showToast(context, 'Please Enter the title');
                }
              } catch (e) {
                throw Exception(e);
              }
            },
            child: const Text('Add Todo'),
          ),
        ],
      ),
    );
  }

  String generateRandomId() {
    final random = Random();
    const chars = '0123456789abcdef';
    String randomId = '';

    for (int i = 0; i < 24; i++) {
      randomId += chars[random.nextInt(chars.length)];
    }

    return randomId;
  }

  void _showToast(BuildContext context, String message) {
    var snackbar = SnackBar(
      content: Text(
        message,
        style: GoogleFonts.montserrat(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      elevation: 20,
      showCloseIcon: true,
      closeIconColor: Colors.red,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
