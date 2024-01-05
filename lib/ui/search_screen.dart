import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:api_integration_with_crud/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController idController = TextEditingController();
  TODO? foundTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search TODO',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Enter TODO ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _searchTodo();
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (foundTodo != null)
              Card(
                child: ListTile(
                  title: Text(foundTodo?.todoName ?? ''),
                  subtitle: Text('ID: ${foundTodo?.id} ?? ' ' '),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _searchTodo() async {
    final String todoId = idController.text.trim();

    if (todoId.isEmpty) {
      Utils.showToast(context, 'Please enter a TODO ID');
      return;
    }

    try {
      final Map<String, dynamic>? result =
          await RemoteService().getTodoById(todoId);

      if (result?['code'] == 200) {
        setState(() {
          foundTodo = TODO.fromJson(result?['data']);
        });
      } else {
        Utils.showToast(context, result?['message']);
      }
    } catch (error) {
      debugPrint(error.toString());
      Utils.showToast(context, 'An error occurred while searching TODO');
    }
  }
}
