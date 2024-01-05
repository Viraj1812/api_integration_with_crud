import 'dart:convert';

import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  final String baseUrl = 'https://calm-plum-jaguar-tutu.cyclic.app/todos';

  Future<List<TODO>> getTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return todosFromJson(response.body);
      } else {
        throw Exception(
            'Failed to get TODOs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get TODOs');
    }
  }

  Future<void> addTodo(TODO newTodo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newTodo.toJson()),
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception(
            'Failed to add TODO. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add TODO: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete TODO. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete TODO');
    }
  }

  Future<void> editTodoById(String id, TODO updatedTodo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedTodo.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to edit TODO. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to edit TODO');
    }
  }

  Future<Map<String, dynamic>> getTodoById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'code': 200, 'data': data};
      } else if (response.statusCode == 404) {
        return {'code': 404, 'message': 'No post with that id.'};
      } else {
        return {'code': response.statusCode, 'message': 'Failed to get TODO'};
      }
    } catch (error) {
      return {'code': 500, 'message': 'Internal Server Error'};
    }
  }
}
