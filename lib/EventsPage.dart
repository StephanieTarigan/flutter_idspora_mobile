import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/Widgets/BottomNavigation.dart';
import 'package:flutter_application_idspora/Events/EventDetailsPage.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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

  // Calculate statistics
  int get totalEvents => _events.length;
  
  int get upcomingEvents {
    final now = DateTime.now();
    return _events.where((event) {
      try {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.isAfter(now) || eventDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
      } catch (e) {
        return false;
      }
    }).length;
  }
  
  int get pastEvents {
    final now = DateTime.now();
    return _events.where((event) {
      try {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.isBefore(DateTime(now.year, now.month, now.day));
      } catch (e) {
        return false;
      }
    }).length;
  }
  
  int get thisMonthEvents {
    final now = DateTime.now();
    return _events.where((event) {
      try {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.year == now.year && eventDate.month == now.month;
      } catch (e) {
        return false;
      }
    }).length;
  }

  List<Event> get upcomingEventsList {
    final now = DateTime.now();
    return _events.where((event) {
      try {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.isAfter(now) || eventDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
      } catch (e) {
        return false;
      }
    }).toList();
  }

  List<Event> get pastEventsList {
    final now = DateTime.now();
    return _events.where((event) {
      try {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.isBefore(DateTime(now.year, now.month, now.day));
      } catch (e) {
        return false;
      }
    }).toList();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  void _showEventDetailDialog(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(event: event),
      ),
    ).then((result) {
      // Refresh data jika ada perubahan dari detail page
      if (result == true) {
        _loadEvents();
      }
    });
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    IconData chipIcon;
    
    switch (status.toLowerCase()) {
      case 'draft':
        chipColor = Colors.grey;
        chipIcon = Icons.edit_rounded;
        break;
      case 'published':
      case 'approved':
        chipColor = Colors.green;
        chipIcon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
      case 'rejected':
        chipColor = Colors.red;
        chipIcon = Icons.cancel_rounded;
        break;
      default:
        chipColor = Colors.orange;
        chipIcon = Icons.info_rounded;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Build horizontal scrollable statistics cards
  Widget _buildSummaryCards() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          SummaryCard(
            title: 'Total Events',
            value: totalEvents.toString(),
            icon: Icons.calendar_month_rounded,
            color: const Color(0xFF8B5CF6),
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'Upcoming Events',
            value: upcomingEvents.toString(),
            icon: Icons.event_available_rounded,
            color: const Color(0xFFF97316),
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'Past Events',
            value: pastEvents.toString(),
            icon: Icons.history_rounded,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'This Month',
            value: thisMonthEvents.toString(),
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildModernEventCard(Event event, {bool isUpcoming = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isUpcoming) ...[
                    _buildActionButton(
                      'Edit',
                      Colors.orange.shade50,
                      Colors.orange,
                      () => _editEvent(event),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Delete',
                      Colors.red.shade50,
                      Colors.red,
                      () => _deleteEvent(event),
                    ),
                  ] else ...[
                    _buildActionButton(
                      'Delete',
                      Colors.red.shade50,
                      Colors.red,
                      () => _deleteEvent(event),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'View',
                      Colors.green.shade50,
                      Colors.green,
                      () => _showEventDetailDialog(event),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${event.date} - ${event.time}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (event.description != null && event.description!.isNotEmpty)
            Text(
              event.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showEventDetailDialog(event),
            child: const Row(
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.orange,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _editEvent(Event event) {
    // Navigate to edit event page
    Navigator.pushNamed(context, '/edit_event', arguments: event).then((result) {
      if (result == true) {
        _loadEvents();
      }
    });
  }

  void _deleteEvent(Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && event.id != null) {
      try {
        final success = await EventController.deleteEvent(event.id!);
        if (success) {
          _showSnackbar('Event deleted successfully');
          _loadEvents(); // Refresh the list
        } else {
          _showSnackbar('Failed to delete event');
        }
      } catch (e) {
        _showSnackbar('Error deleting event: $e');
      }
    }
  }

  void _showAddEventBottomSheet() {
    Navigator.pushNamed(context, '/add_events').then((result) {
      if (result == true) {
        _loadEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black87),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        color: Colors.orange,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Horizontal Scrollable Statistics Cards
                    _buildSummaryCards(),
                    
                    const SizedBox(height: 8),
                    
                    // Upcoming Events Section
                    if (upcomingEventsList.isNotEmpty) ...[
                      _buildSectionTitle('Upcoming Events'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: upcomingEventsList
                              .map((event) => _buildModernEventCard(event, isUpcoming: true))
                              .toList(),
                        ),
                      ),
                    ],
                    
                    // History Section
                    if (pastEventsList.isNotEmpty) ...[
                      _buildSectionTitle('History'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: pastEventsList
                              .map((event) => _buildModernEventCard(event, isUpcoming: false))
                              .toList(),
                        ),
                      ),
                    ],
                    
                    // Empty State
                    if (_events.isEmpty) ...[
                      const SizedBox(height: 60),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.event_busy_rounded,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No events found',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pull down to refresh or add a new event',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: _showAddEventBottomSheet,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Event'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEventBottomSheet,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Event',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentRoute: '/event'),
    );
  }
}

// SummaryCard Widget
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
