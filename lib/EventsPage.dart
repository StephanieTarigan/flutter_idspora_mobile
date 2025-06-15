import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/Widgets/BottomNavigation.dart';
import 'package:flutter_application_idspora/Events/EventDetailsPage.dart';
import 'package:flutter_application_idspora/Events/edit_events.dart';
import 'package:flutter_application_idspora/widgets/SummaryCard.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  List<Event> _events = [];
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadEvents();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        backgroundColor: Colors.amber.shade800,
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
        chipColor = Colors.amber;
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
            color: const Color(0xFF667EEA),
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'Upcoming Events',
            value: upcomingEvents.toString(),
            icon: Icons.event_available_rounded,
            color: Colors.amber,
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'Past Events',
            value: pastEvents.toString(),
            icon: Icons.history_rounded,
            color: const Color.fromARGB(255, 198, 83, 142),
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

  Widget _buildEventCard(Event event, {bool isUpcoming = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini untuk alignment atas
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ),
              const SizedBox(width: 12), // Tambahkan spacing
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini juga
                children: [
                  if (isUpcoming) ...[
                    _buildActionButton(
                      'Edit',
                      Colors.amber.withOpacity(0.1),
                      Colors.amber,
                      () => _editEvent(event),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'Delete',
                      Colors.red.withOpacity(0.1),
                      Colors.red,
                      () => _deleteEvent(event),
                    ),
                  ] else ...[
                    _buildActionButton(
                      'Delete',
                      Colors.red.withOpacity(0.1),
                      Colors.red,
                      () => _deleteEvent(event),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      'View',
                      Colors.green.withOpacity(0.1),
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
            '${event.date} - ${event.time}:00',
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
            child: Row(
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.amber.shade700,
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
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A202C),
        ),
      ),
    );
  }

  void _editEvent(Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: event),
      ),
    );
    if (result == true) {
      _loadEvents();
    }
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
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D3748)),
              onPressed: () {
                HapticFeedback.lightImpact();
                _loadEvents();
              },
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: _loadEvents,
            color: Colors.amber,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
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
                                  .map((event) => _buildEventCard(event, isUpcoming: true))
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
                                  .map((event) => _buildEventCard(event, isUpcoming: false))
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
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.event_busy_rounded,
                                    size: 40,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No events found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pull down to refresh or add a new event',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
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
        ),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showAddEventBottomSheet();
          },
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Event',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentRoute: '/event'),
    );
  }
}