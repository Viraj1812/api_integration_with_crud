import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:api_integration_with_crud/ui/add_task_screen.dart';
import 'package:api_integration_with_crud/ui/search_screen.dart';
import 'package:api_integration_with_crud/widgets/edit_dialog.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _navigateToSearchScreen(context);
            },
          ),
        ],
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
                onEdit: () {
                  onEdit(todo, index);
                },
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

  void _navigateToSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
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

  void onEdit(TODO todo, int index) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTodoDialog(
          initialTitle: todoList?[index].todoName ?? '',
          initialIsCompleted: todoList?[index].isComplete ?? false,
        );
      },
    );

    if (result != null) {
      setState(() {
        todoList?[index].isComplete = result['isCompleted'];
      });

      try {
        await RemoteService().editTodoById(
          todoList?[index].id ?? '',
          todoList?[index] ?? todo,
        );
      } catch (e) {
        _showToast(context, e.toString());
      }
    }
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
