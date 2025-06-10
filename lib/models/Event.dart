class Event {
  final int? id; // misalnya API juga mengirimkan id
  final String title;
  final String date;
  final String time;
  final String category;
  final String venue;
  final int capacity;
  final String speaker;
  final String mc;
  final String? description;
  final String status;

  Event({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.category,
    required this.venue,
    required this.capacity,
    required this.speaker,
    required this.mc,
    this.description,
    required this.status,
  });

  // Factory method untuk parsing JSON dari API
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      category: json['category'],
      venue: json['venue'],
      capacity: json['capacity'],
      speaker: json['speaker'],
      mc: json['mc'],
      description: json['description'],
      status: json['status'],
    );
  }

  // Konversi ke JSON (misal untuk POST ke API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'category': category,
      'venue': venue,
      'capacity': capacity,
      'speaker': speaker,
      'mc': mc,
      'description': description,
      'status': status,
    };
  }
}
