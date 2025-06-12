class Event {
  final int? id;
  final String title;
  final String date;
  final String time;
  final String category;
  final String venue;
  final int capacity;
  final String speaker;
  final String mc;
  final String? description;

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
      capacity: json['capacity'] is String 
          ? int.parse(json['capacity']) 
          : json['capacity'], // Handle both String and int from API
      speaker: json['speaker'],
      mc: json['mc'],
      description: json['description'],
    );
  }

  // Konversi ke JSON (untuk POST/PUT ke API)
  Map<String, dynamic> toJson() {
  return {
    if (id != null) 'id': id,
    'title': title,
    'date': date,
    'time': time,
    'category': category,
    'venue': venue,
    'capacity': capacity,
    'speaker': speaker,
    'mc': mc,
    'description': description ?? '', // mastiin g null
  };
}
}
