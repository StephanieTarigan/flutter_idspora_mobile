import 'package:flutter/material.dart';
import 'Events/eventdetailspage.dart';
import 'Events/add_events.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  // Data untuk event yang akan datang
  final List<Map<String, String>> upcomingEvents = [
    {
      'title': 'Dari Wireframe ke Wow: Figma untuk Pemula UI/UX',
      'category': 'UI/UX Design',
      'date': '2025-05-04 pukul 03:38',
      'venue': 'Aula FIT',
      'capacity': '100 orang',
      'speaker': 'Arya',
      'mc': 'Stephanie',
      'description': 'Pelajari dasar-dasar desain UI/UX menggunakan Figma.',
      'status': 'Upcoming',
      'imagePath':
          'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    },
  ];

  // Data untuk event hari ini
  final List<Map<String, String>> todayEvents = [
    {
      'title': 'Workshop Pengembangan Aplikasi Mobile',
      'category': 'Development',
      'date': '2025-05-07 pukul 10:00',
      'venue': 'Online',
      'capacity': '50 orang',
      'speaker': 'Fathan',
      'mc': 'Maria',
      'description': 'Pelajari cara membangun aplikasi mobile dengan Flutter.',
      'status': 'Today',
      'imagePath':
          'https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    },
  ];

  // Data untuk event yang sudah berlalu
  final List<Map<String, String>> pastEvents = [
    {
      'title': 'Konferensi Web Development',
      'category': 'Development',
      'date': '2025-04-15 pukul 09:00',
      'venue': 'TUCH',
      'capacity': '200 orang',
      'speaker': 'Agvin',
      'mc': 'Dini',
      'description':
          'Konferensi tahunan tentang pengembangan web yang membahas tren dan teknologi terbaru.',
      'status': 'Past',
      'imagePath':
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'), // Judul halaman
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Tombol kembali
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab filter untuk kategori event
              _buildFilterTabs(),
              const SizedBox(height: 20),

              // Menampilkan event yang akan datang
              const Text(
                'Upcoming Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...upcomingEvents.map((event) => _buildEventItem(context, event)),

              const SizedBox(height: 16),

              // Menampilkan event hari ini
              const Text(
                'Today Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...todayEvents.map((event) => _buildEventItem(context, event)),

              const SizedBox(height: 16),

              // Menampilkan event yang sudah berlalu
              const Text(
                'Past Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...pastEvents.map((event) => _buildEventItem(context, event)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman tambah event
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEvents()),
          );
          if (newEvent != null && newEvent is Map<String, String>) {
            // Menambahkan event baru ke kategori yang sesuai
            setState(() {
              if (newEvent['status'] == 'Upcoming') {
                upcomingEvents.add(newEvent);
              } else if (newEvent['status'] == 'Today') {
                todayEvents.add(newEvent);
              } else if (newEvent['status'] == 'Past') {
                pastEvents.add(newEvent);
              }
            });
          }
        },
        backgroundColor: Colors.amber, // Warna tombol tambah
        child: const Icon(Icons.add, color: Colors.black), // Ikon tambah
      ),
      bottomNavigationBar: _buildBottomNavigation(context), // Navigasi bawah
    );
  }

  // Widget untuk membuat tab filter
  Widget _buildFilterTabs() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Tab "All"
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'All',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // Tab "Upcoming"
          Expanded(
            child: Container(
              child: const Center(
                child: Text('Upcoming', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          // Tab "Today"
          Expanded(
            child: Container(
              child: const Center(
                child: Text('Today', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          // Tab "Past"
          Expanded(
            child: Container(
              child: const Center(
                child: Text('Past', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan item event
  Widget _buildEventItem(BuildContext context, Map<String, String> event) {
    // Menentukan warna berdasarkan status event
    Color statusColor;
    switch (event['status']) {
      case 'Upcoming':
        statusColor = Colors.blue;
        break;
      case 'Today':
        statusColor = Colors.green;
        break;
      case 'Past':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail event
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(
              title: event['title'] ?? '',
              category: event['category'] ?? '',
              date: event['date'] ?? '',
              venue: event['venue'] ?? '',
              capacity: event['capacity'] ?? '',
              speaker: event['speaker'] ?? '',
              mc: event['mc'] ?? '',
              description: event['description'] ?? '',
              status: event['status'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar event dengan badge status
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    event['imagePath'] ?? '',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event['status'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Detail event
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event['category'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event['date'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk navigasi bawah
  Widget _buildBottomNavigation(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Home', false),
              _buildNavItem(context, 1, Icons.task, 'Task', false),
              _buildNavItem(context, 2, Icons.event, 'Event', true),
              _buildNavItem(
                context,
                3,
                Icons.account_balance_wallet,
                'Finance',
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk item navigasi bawah
  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/task');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/events');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/finance');
              break;
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}