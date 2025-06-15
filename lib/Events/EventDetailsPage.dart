import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/Events/edit_events.dart';
import 'package:flutter_application_idspora/Events/Needs.dart';
import 'package:flutter_application_idspora/Events/add_needs.dart';

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

  // Navigate to add needs page
  void _addNeed() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNeedsPage(event: _event),
        ),
      );

      if (result == true && mounted) {
        _showSnackbar('Need added successfully!');
      }
    } catch (e) {
      print('Error navigating to Add Needs: $e');
      if (mounted) {
        _showSnackbar('Error opening Add Needs page');
      }
    }
  }

  void _showSnackbar(String message) {
    if (mounted) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete "${_event.title}"?'),
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

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await EventController.deleteEvent(_event.id!);
        if (success) {
          _showSnackbar('Event deleted successfully');
          Navigator.pop(context, true);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Event Details',
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Header (Amber Section)
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
                            iconColor: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.location_on_outlined,
                            title: 'Venue',
                            value: _event.venue,
                            iconColor: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.people_outlined,
                            title: 'Capacity',
                            value: '${_event.capacity} people',
                            iconColor: Colors.amber,
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
                          backgroundColor: Colors.amber.withOpacity(0.1),
                          iconColor: Colors.amber,
                        ),
                        const SizedBox(height: 16),
                        _buildTeamMember(
                          role: 'Master of Ceremony',
                          name: _event.mc,
                          iconData: Icons.mic_none_rounded,
                          backgroundColor: Colors.amber.withOpacity(0.1),
                          iconColor: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  
                  // Description Section
                  _buildSectionTitle('Description'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
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
                      child: Text(
                        _event.description ?? 'No description provided.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A202C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Kebutuhan Acara Section with Add Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kebutuhan Acara',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _addNeed();
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add Need'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Widget tabel kebutuhan (NeedsTable) dengan data dummy
                  NeedsTable(
                    tasks: [
                      EventTask(
                        id: 1,
                        eventId: _event.id ?? 0,
                        title: 'Laptop untuk presentasi',
                        category: 'Peralatan & Logistik',
                        description: 'Laptop untuk kebutuhan presentasi narasumber.',
                        status: 'draft',
                        approvalNotes: 'Pastikan baterai penuh.',
                        createdAt: null,
                        updatedAt: null,
                      ),
                      EventTask(
                        id: 2,
                        eventId: _event.id ?? 0,
                        title: 'Air mineral',
                        category: 'Konsumsi',
                        description: 'Air mineral untuk peserta dan panitia.',
                        status: 'approved',
                        approvalNotes: '',
                        createdAt: null,
                        updatedAt: null,
                      ),
                      EventTask(
                        id: 3,
                        eventId: _event.id ?? 0,
                        title: 'Sertifikat peserta',
                        category: 'Dokumen & Administrasi',
                        description: 'Cetak sertifikat untuk seluruh peserta.',
                        status: 'draft',
                        approvalNotes: null,
                        createdAt: null,
                        updatedAt: null,
                      ),
                    ],
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
        color: Colors.amber,
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
                    textColor: Colors.amber,
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

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
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
              color: Color(0xFF1A202C),
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
          color: Color(0xFF1A202C),
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
    return Container(
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
      child: Row(
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
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}