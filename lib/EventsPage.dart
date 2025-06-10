import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/models/Event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();
  List<Event> _events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final events = await EventController.fetchEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      _showSnackbar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showEventDetailDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${event.category}'),
              Text('Date: ${event.date}'),
              Text('Time: ${event.time}'),
              Text('Venue: ${event.venue}'),
              Text('Capacity: ${event.capacity}'),
              Text('Speaker: ${event.speaker}'),
              Text('MC: ${event.mc}'),
              Text('Description: ${event.description ?? "-"}'),
              Text('Status: ${event.status}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventBottomSheet() {
    final rootContext = context; // Simpan context utama

    final _titleController = TextEditingController();
    final _categoryController = TextEditingController();
    final _venueController = TextEditingController();
    final _capacityController = TextEditingController();
    final _speakerController = TextEditingController();
    final _mcController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _dateController = TextEditingController();
    final _timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Add New Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),
                TextField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _speakerController,
                  decoration: const InputDecoration(labelText: 'Speaker'),
                ),
                TextField(
                  controller: _mcController,
                  decoration: const InputDecoration(labelText: 'MC'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                  ),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time (HH:MM:SS)',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Validasi
                    if (_titleController.text.isEmpty ||
                        _categoryController.text.isEmpty ||
                        _venueController.text.isEmpty ||
                        _capacityController.text.isEmpty ||
                        _speakerController.text.isEmpty ||
                        _mcController.text.isEmpty ||
                        _dateController.text.isEmpty ||
                        _timeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields!'),
                        ),
                      );
                      return;
                    }

                    final capacity =
                        int.tryParse(_capacityController.text) ?? 0;

                    final newEvent = Event(
                      id: 0,
                      title: _titleController.text,
                      category: _categoryController.text,
                      venue: _venueController.text,
                      capacity: capacity,
                      speaker: _speakerController.text,
                      mc: _mcController.text,
                      description: _descriptionController.text.isEmpty
                          ? null
                          : _descriptionController.text,
                      date: _dateController.text,
                      time: _timeController.text,
                      status: 'draft',
                    );

                    try {
                      await EventController.createEvent(newEvent);

                      // ✅ Tutup modal (pakai context rootNavigator biar pasti modal yang tertutup)
                      Navigator.of(rootContext, rootNavigator: true).pop();

                      // ✅ Tampilkan snackbar di layar utama
                      if (mounted) {
                        _showSnackbar('Event created successfully!');
                        _loadEvents();
                      }
                    } catch (e) {
                      // Snackbar muncul di modal kalau error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create event: $e')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? const Center(child: Text('No events found.'))
              : ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.category),
                      onTap: () => _showEventDetailDialog(event),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
