import 'dart:convert';

import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/utils/helper_methods.dart';
import 'package:dio/dio.dart';

class RemoteService {
  final String baseUrl = 'https://calm-plum-jaguar-tutu.cyclic.app/todos';

  Dio dio = Dio();

  Future<List<TODO>> getTodos() async {
    try {
      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        final rawData = response.data;
        final jsonString = rawData is String ? rawData : json.encode(rawData);

        return todosFromJson(jsonString);
      } else {
        throw Exception(
            'Failed to get TODOs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get TODOs: $e');
    }
  }

  Future<void> addTodo(TODO newTodo) async {
    const maxRetries = 3;
    int retries = 0;

    while (retries < maxRetries) {
      try {
        final response = await dio.post(
          baseUrl,
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: jsonEncode(newTodo.toJson()),
        );

        if (response.statusCode == 200) {
          break;
        } else if (response.statusCode == 429) {
          await Future.delayed(Duration(seconds: 2 ^ retries));
          retries++;
        } else {
          throw Exception(
              'Failed to add TODO. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to add TODO: $e');
      }
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final response = await dio.delete('$baseUrl/$id');

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
      final response = await dio.put(
        '$baseUrl/$id',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(updatedTodo.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to edit TODO. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to edit TODO');
    }
  }

  Future<Map<String, dynamic>>? getTodoById(String id) async {
    try {
      final response = await dio.get('$baseUrl/$id');

      if (response.statusCode == 200) {
        return {'code': 200, 'data': response.data['data']};
      } else if (response.statusCode == 404) {
        return {'code': 404, 'message': 'No post with that id.'};
      } else {
        return {'code': response.statusCode, 'message': 'Failed to get TODO'};
      }
    } catch (error) {
      return {'code': 500, 'message': 'Internal Server Error'};
    }
  }

  Future<Map<String, dynamic>> getTodosByDateRange(
      DateTime? startDate, DateTime? endDate) async {
    final startDate0 = Utils.formatDate(startDate ?? DateTime.now());
    final endDate0 = Utils.formatDate(endDate ?? DateTime.now());

    try {
      final response = await dio.get('$baseUrl/from/$startDate0/to/$endDate0');

      if (response.statusCode == 200) {
        return {'code': 200, 'data': response.data['data']};
      } else if (response.statusCode == 404) {
        return {
          'code': 404,
          'message':
              'Todos Not Found at ${startDate?.toIso8601String()} - ${endDate?.toIso8601String()}'
        };
      } else {
        return {'code': response.statusCode, 'message': 'Failed to get TODOs'};
      }
    } catch (error) {
      return {'code': 500, 'message': 'Internal Server Error'};
    }
  }
}
