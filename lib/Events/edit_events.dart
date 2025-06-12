import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final Event event;

  const EditEventPage({
    super.key,
    required this.event,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _venueController;
  late TextEditingController _capacityController;
  late TextEditingController _speakerController;
  late TextEditingController _mcController;
  late TextEditingController _statusController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  // Category options
  final List<String> _categories = [
    'webinar',
    'seminar',
    'workshop',
    'pelatihan',
    'talkshow',
    'lomba',
    'bootcamp',
    'kuliah_umum',
    'diskusi',
    'lainnya',
  ];

  final List<String> _statusList = [
    'draft',
    'submitted',
    'approved',
    'rejected',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with event data
    _titleController = TextEditingController(text: widget.event.title);
    _categoryController = TextEditingController(text: widget.event.category);
    _venueController = TextEditingController(text: widget.event.venue);
    _capacityController = TextEditingController(text: widget.event.capacity.toString());
    _speakerController = TextEditingController(text: widget.event.speaker);
    _mcController = TextEditingController(text: widget.event.mc);
    _statusController = TextEditingController(text: widget.event.status);
    _descriptionController = TextEditingController(text: widget.event.description ?? '');

    // Parse date and time
    try {
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.event.date);
    } catch (e) {
      _selectedDate = DateTime.now();
    }

    try {
      final timeParts = widget.event.time.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    } catch (e) {
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _venueController.dispose();
    _capacityController.dispose();
    _speakerController.dispose();
    _mcController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
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

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final eventData = {
        'title': _titleController.text,
        'category': _categoryController.text,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'time': '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00',
        'venue': _venueController.text,
        'capacity': _capacityController.text,
        'speaker': _speakerController.text,
        'mc': _mcController.text,
        'description': _descriptionController.text,
        'status': _statusController.text,
      };

      await EventController.updateEvent(widget.event.id!, eventData);
      
      if (!mounted) return;
      _showSnackbar('Event updated successfully');
      Navigator.pop(context, true); // Return with refresh flag
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('Error updating event: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Event Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an event title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Event Category
                        DropdownButtonFormField<String>(
                          value: _categoryController.text.isNotEmpty
                              ? _categoryController.text
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _categoryController.text = newValue ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Event Date and Time
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[400]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[400]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedTime.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Venue
                        TextFormField(
                          controller: _venueController,
                          decoration: const InputDecoration(
                            labelText: 'Venue',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a venue';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Capacity
                        TextFormField(
                          controller: _capacityController,
                          decoration: const InputDecoration(
                            labelText: 'Capacity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter capacity';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Speaker
                        TextFormField(
                          controller: _speakerController,
                          decoration: const InputDecoration(
                            labelText: 'Speaker',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter speaker name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // MC
                        TextFormField(
                          controller: _mcController,
                          decoration: const InputDecoration(
                            labelText: 'MC',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter MC name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Status
                        DropdownButtonFormField<String>(
                          value: _statusController.text.isNotEmpty
                              ? _statusController.text
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: _statusList.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _statusController.text = newValue ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a status';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _updateEvent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update Event',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
