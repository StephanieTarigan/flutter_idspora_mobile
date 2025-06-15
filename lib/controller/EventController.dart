import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventController {
  static const String baseUrl = 'http://127.0.0.1:8000/api/events';

  // Helper method untuk mendapatkan headers dengan token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET all events
  static Future<List<Event>> fetchEvents() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  // GET single event by ID
  static Future<Event> fetchEventById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }

  // POST - Create new event
  static Future<Event> createEvent(Event event) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(event.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to create event: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  static Future<Event> createEventFromMap(Map<String, dynamic> eventData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(eventData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to create event: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  // PUT - Update existing event
  static Future<Event> updateEvent(int id, Map<String, dynamic> eventData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: json.encode(eventData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to update event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // Alternative updateEvent method yang menerima Event object
  static Future<Event> updateEventObject(int id, Event event) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: json.encode(event.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to update event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // DELETE - Delete event
  static Future<bool> deleteEvent(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }
}
