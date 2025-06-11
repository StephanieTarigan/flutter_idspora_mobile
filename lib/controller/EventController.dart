import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventController {
  static const String baseUrl = 'http://127.0.0.1:8000/api/events';

  // GET all events (dengan token)
  static Future<List<Event>> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  // POST event baru (dengan token)
  static Future<Event> createEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(event.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Event.fromJson(data);
    } else {
      throw Exception('Failed to create event: ${response.body}');
    }
  }
}