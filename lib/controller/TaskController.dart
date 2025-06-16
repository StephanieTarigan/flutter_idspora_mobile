import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_idspora/tasks/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController {
  static const String baseUrl = 'http://127.0.0.1:8000/api/tasks';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Task>> fetchTasks() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  static Future<Task> fetchTaskById(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body)['data'];
        return Task.fromJson(data);
      } else {
        throw Exception('Failed to load task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  static Future<Task> createTask(Task task) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Task.fromJson(data);
      } else {
        throw Exception('Failed to create task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  static Future<Task> createTaskFromMap(Map<String, dynamic> taskData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(taskData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Task.fromJson(data);
      } else {
        throw Exception('Failed to create task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  static Future<Task> updateTask(String id, Map<String, dynamic> taskData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: json.encode(taskData),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Task.fromJson(data);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  static Future<Task> updateTaskObject(String id, Task task) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Task.fromJson(data);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  static Future<bool> deleteTask(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
}