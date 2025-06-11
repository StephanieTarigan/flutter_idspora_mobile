import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/Widgets/BottomNavigation.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();
  List<Event> _events = [];
  bool _isLoading = false;
  DateTime? _selectedDate;

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
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _showEventDetailDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(Icons.category, 'Category', event.category),
                _buildDetailItem(Icons.calendar_today, 'Date', event.date),
                _buildDetailItem(Icons.access_time, 'Time', event.time),
                _buildDetailItem(Icons.location_on, 'Venue', event.venue),
                _buildDetailItem(Icons.people, 'Capacity', event.capacity.toString()),
                _buildDetailItem(Icons.person, 'Speaker', event.speaker),
                _buildDetailItem(Icons.mic, 'MC', event.mc),
                _buildDetailItem(Icons.description, 'Description', event.description ?? "-"),
                _buildDetailItem(Icons.info, 'Status', _getStatusChip(event.status)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                value is Widget
                    ? value
                    : Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    IconData chipIcon;
    
    switch (status.toLowerCase()) {
      case 'draft':
        chipColor = Colors.grey;
        chipIcon = Icons.edit;
        break;
      case 'published':
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        chipIcon = Icons.cancel;
        break;
      default:
        chipColor = Colors.amber;
        chipIcon = Icons.info;
    }
    
    return Chip(
      avatar: Icon(chipIcon, size: 16, color: Colors.white),
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        controller.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }

  void _showAddEventBottomSheet() {
    // Navigate to the add events page instead of showing bottom sheet
    Navigator.pushNamed(context, '/add_events');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pull down to refresh or add a new event',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _showAddEventBottomSheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber.shade100,
                            child: const Icon(Icons.event, color: Colors.amber),
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(event.category),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.date,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.time,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: _getStatusChip(event.status),
                          onTap: () => _showEventDetailDialog(event),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventBottomSheet,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: const BottomNavigation(currentRoute: '/event'),
    );
  }
}