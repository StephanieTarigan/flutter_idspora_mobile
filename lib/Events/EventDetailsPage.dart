import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/Events/edit_events.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Event _event;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  // Refresh event data from API
  Future<void> _refreshEventData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedEvent = await EventController.fetchEventById(_event.id!);
      setState(() {
        _event = updatedEvent;
      });
    } catch (e) {
      _showSnackbar('Error refreshing event data: $e');
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  // Navigate to edit event page
  void _editEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: _event),
      ),
    );

    if (result == true) {
      _refreshEventData();
    }
  }

  // Delete event
  void _deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${_event.title}"?'),
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

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await EventController.deleteEvent(_event.id!);
        if (success) {
          _showSnackbar('Event deleted successfully');
          Navigator.pop(context, true); // Return to previous screen with refresh flag
        } else {
          _showSnackbar('Failed to delete event');
        }
      } catch (e) {
        _showSnackbar('Error deleting event: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan warna berdasarkan status acara
    Color statusColor;
    switch (_event.status.toLowerCase()) {
      case 'upcoming':
        statusColor = Colors.green;
        break;
      case 'draft':
        statusColor = Colors.grey;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Event Details',
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Header (Orange Section)
                  _buildEventHeader(),
                  
                  // Event Details Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.category_outlined,
                            title: 'Category',
                            value: _event.category,
                            iconColor: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.location_on_outlined,
                            title: 'Venue',
                            value: _event.venue,
                            iconColor: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.people_outlined,
                            title: 'Capacity',
                            value: '${_event.capacity} people',
                            iconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Event Team Section
                  _buildSectionTitle('Event Team'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildTeamMember(
                          role: 'Speaker',
                          name: _event.speaker,
                          iconData: Icons.person_outline_rounded,
                          backgroundColor: const Color(0xFFFFF3E0),
                          iconColor: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        _buildTeamMember(
                          role: 'Master of Ceremony',
                          name: _event.mc,
                          iconData: Icons.mic_none_rounded,
                          backgroundColor: const Color(0xFFFFF3E0),
                          iconColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  
                  // Description Section
                  _buildSectionTitle('Description'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _event.description ?? 'No description provided.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildEventHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.orange,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _event.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: _editEvent,
                    backgroundColor: Colors.white,
                    textColor: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline_rounded,
                    onPressed: _deleteEvent,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusBadge(_event.status),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_event.date} at ${_event.time}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    
    switch (status.toLowerCase()) {
      case 'upcoming':
        badgeColor = Colors.green;
        break;
      case 'draft':
        badgeColor = Colors.grey;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.green;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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

  Widget _buildTeamMember({
    required String role,
    required String name,
    required IconData iconData,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}