import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_idspora/models/Event.dart';

class EventController {
  static const String baseUrl = 'http://127.0.0.1:8000/api/events';

  // GET all events
  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  // POST event baru
  static Future<Event> createEvent(Event event) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Event.fromJson(data);
    } else {
      throw Exception('Failed to create event');
    }
  }
}
