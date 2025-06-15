class EventTask {
  final int id;
  final int eventId;
  final String title;
  final String category;
  final String description;
  final String status;
  final String? approvalNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventTask({
    required this.id,
    required this.eventId,
    required this.title,
    required this.category,
    required this.description,
    required this.status,
    this.approvalNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory EventTask.fromJson(Map<String, dynamic> json) {
    return EventTask(
      id: json['id'],
      eventId: json['event_id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      status: json['status'],
      approvalNotes: json['approval_notes'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}