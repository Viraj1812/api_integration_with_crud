import 'dart:math';

import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:api_integration_with_crud/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  bool isCompleted = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title text';
                    }
                    return null;
                  },
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
                  // Validate the form before adding a new task
                  if (_formKey.currentState?.validate() ?? false) {
                    String randomId = generateRandomId();
                    TODO newTask = TODO(
                      id: randomId,
                      todoName: titleController.text,
                      isComplete: isCompleted,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      v: 0,
                    );
                    await RemoteService().addTodo(newTask);
                    Utils.showToast(context, 'TODO Added Successfully!');
                    Navigator.pop(context, newTask);
                  }
                } catch (e) {
                  throw Exception(e);
                }
              },
              child: const Text('Add Todo'),
            ),
          ],
        ),
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
}
