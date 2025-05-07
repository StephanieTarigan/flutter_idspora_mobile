import 'package:flutter/material.dart';

enum TaskStatus {
  todo,
  inProgress,
  done
}

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return const Color(0xFFFFA726); // Orange
      case TaskStatus.inProgress:
        return const Color(0xFF5C8AEE); // Blue
      case TaskStatus.done:
        return const Color(0xFF66BB6A); // Green
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String assignedTo;
  final TaskStatus status;
  final double progress;
  final int priority; // 1-3, where 3 is highest

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedTo,
    required this.status,
    this.progress = 0.0,
    this.priority = 2,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? assignedTo,
    TaskStatus? status,
    double? progress,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      priority: priority ?? this.priority,
    );
  }
}

List<Task> getSampleTasks() {
  return [
    Task(
      id: '1',
      title: 'Upload Flyer Seminar',
      description: 'Design and upload the flyer for the upcoming seminar on digital marketing strategies. Make sure to include all speaker information, date, time, and venue details. The flyer should be in both portrait and landscape formats for different platforms.',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      assignedTo: 'Maria',
      status: TaskStatus.todo,
      progress: 0.3,
      priority: 3,
    ),
    Task(
      id: '2',
      title: 'Update Link Registrasi',
      description: 'Update the registration link for the event on the website and all social media platforms. Ensure the link works properly and redirects to the correct registration form. Test the form submission process to verify data is being captured correctly.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      assignedTo: 'Agvin Amalia',
      status: TaskStatus.inProgress,
      progress: 0.7,
      priority: 2,
    ),
    Task(
      id: '3',
      title: 'Verifikasi Narasumber',
      description: 'Contact and verify all speakers for the upcoming event, confirm their schedules and presentation topics. Send them the event agenda and collect their presentation materials. Arrange for their transportation and accommodation if needed.',
      dueDate: DateTime.now(),
      assignedTo: 'Alea Atapasya',
      status: TaskStatus.done,
      progress: 1.0,
      priority: 3,
    ),
    Task(
      id: '4',
      title: 'Prepare Meeting Room',
      description: 'Set up the meeting room with all necessary equipment for the board meeting tomorrow. Check the projector, sound system, and video conferencing equipment. Arrange seating and prepare printed materials for all attendees.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      assignedTo: 'Fathan',
      status: TaskStatus.todo,
      progress: 0.1,
      priority: 2,
    ),
    Task(
      id: '5',
      title: 'Send Monthly Report',
      description: 'Compile and send the monthly performance report to all department heads. Include key metrics, achievements, challenges, and plans for the next month. Make sure all data is accurate and up-to-date.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      assignedTo: 'Alea Atapasya',
      status: TaskStatus.done,
      progress: 1.0,
      priority: 1,
    ),
  ];
}

// Global task list that can be modified
List<Task> globalTasks = getSampleTasks();
