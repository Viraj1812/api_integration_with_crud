import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListItem extends StatelessWidget {
  final TODO todo;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggle;

  const TodoListItem({
    super.key,
    required this.todo,
    this.onEdit,
    this.onDelete,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.todoName,
        style:
            GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Created: ${_formatDateTime(todo.createdAt)}'),
          Text('Updated: ${_formatDateTime(todo.updatedAt)}'),
        ],
      ),
      leading: GestureDetector(
        onTap: onToggle,
        child: Icon(
          todo.isComplete == true
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color: todo.isComplete == true ? Colors.green : Colors.grey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.toLocal().toLocal().toLocal()}'.split(' ')[0];
  }
}
