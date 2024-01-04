import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:api_integration_with_crud/ui/add_task_screen.dart';
import 'package:api_integration_with_crud/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TODO>? todoList;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO APP',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: todoList?.length ?? 0,
          itemBuilder: (context, index) {
            TODO? todo = todoList?[index];
            if (todo != null) {
              return TodoListItem(
                todo: todo,
                onEdit: () {},
                onDelete: () {
                  onDelete(todo);
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTodoScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTodoScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    ).then((value) => handleState(value));
  }

  void handleState(TODO item) async {
    setState(() {
      todoList?.add(item);
    });
  }

  void getData() async {
    todoList = await RemoteService().getTodos();
    if (todoList != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  void onDelete(TODO todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this TODO?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await RemoteService().deleteTodo(todo.id);
                handleDelete(todo);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void handleDelete(TODO todo) {
    setState(() {
      todoList?.remove(todo);
    });
  }
}
