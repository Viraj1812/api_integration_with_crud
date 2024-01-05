import 'package:flutter/material.dart';

class EditTodoDialog extends StatefulWidget {
  final String initialTitle;
  final bool initialIsCompleted;

  const EditTodoDialog({
    Key? key,
    required this.initialTitle,
    required this.initialIsCompleted,
  }) : super(key: key);

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _isCompleted = widget.initialIsCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Enter edited title'),
            enabled: false,
          ),
          Row(
            children: [
              const Text('Completed'),
              Switch(
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              {
                'isCompleted': _isCompleted,
              },
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
