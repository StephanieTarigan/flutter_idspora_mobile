import 'package:flutter/material.dart';
import 'events_agenda.dart';
import 'events_requirements.dart';

// Widget utama untuk menampilkan detail acara
class EventDetailsPage extends StatelessWidget {
  // Properti untuk menyimpan informasi detail acara
  final String title; 
  final String category; 
  final String date; 
  final String venue; 
  final String capacity; 
  final String speaker;
  final String mc; 
  final String description;
  final String status;

  const EventDetailsPage({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.venue,
    required this.capacity,
    required this.speaker,
    required this.mc,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan warna berdasarkan status acara
    Color statusColor;
    switch (status) {
      case 'Upcoming':
        statusColor = Colors.blue; // Warna biru untuk acara mendatang
        break;
      case 'Today':
        statusColor = Colors.green; // Warna hijau untuk acara hari ini
        break;
      case 'Past':
        statusColor = Colors.grey; // Warna abu-abu untuk acara yang sudah berlalu
        break;
      default:
        statusColor = Colors.blue; // Default warna biru
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar untuk menampilkan gambar header acara
            SliverAppBar(
              expandedHeight: 200, // Tinggi header
              pinned: true, // Header tetap terlihat saat scroll
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar latar belakang header
                    Image.network(
                      'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                      fit: BoxFit.cover,
                    ),
                    // Gradien untuk efek gelap di bagian bawah gambar
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Judul acara di bagian bawah header
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol kembali di AppBar
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
              ),
              // Tombol aksi (edit dan delete)
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Fungsi untuk mengedit acara
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Fungsi untuk menghapus acara
                  },
                ),
              ],
            ),

            // Bagian detail acara
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge status acara
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor, // Warna sesuai status
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Detail tanggal acara
                    _buildDetailItem(Icons.calendar_today, 'Date', date),
                    const SizedBox(height: 12),

                    // Detail kategori acara
                    _buildDetailItem(Icons.category, 'Category', category),
                    const SizedBox(height: 12),

                    // Detail tempat acara
                    _buildDetailItem(Icons.location_on, 'Venue', venue),
                    const SizedBox(height: 12),

                    // Detail kapasitas acara
                    _buildDetailItem(Icons.people, 'Capacity', capacity),
                    const SizedBox(height: 12),

                    // Bagian tim acara
                    const Text(
                      'Event Team',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Detail pembicara
                    _buildTeamMember('Speaker', speaker),
                    const SizedBox(height: 8),

                    // Detail MC
                    _buildTeamMember('Master of Ceremony', mc),
                    const SizedBox(height: 16),

                    // Bagian deskripsi acara
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bagian peserta acara
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Participants',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '5/100', // Contoh jumlah peserta
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Avatar peserta
                    _buildParticipantsAvatars(),
                    const SizedBox(height: 24),

                    // Tombol aksi (Agenda dan Requirements)
                    Row(
                      children: [
                        // Tombol untuk melihat agenda acara
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventsAgenda(eventTitle: title),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Agenda'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol untuk melihat persyaratan acara
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventsRequirements(eventTitle: title),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0E1330),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Requirements'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail acara (ikon + label + nilai)
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]), // Ikon detail
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label, // Label detail
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value, // Nilai detail
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk menampilkan anggota tim acara (role + nama)
  Widget _buildTeamMember(String role, String name) {
    return Row(
      children: [
        // Avatar anggota tim
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        // Detail role dan nama
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk menampilkan avatar peserta
  Widget _buildParticipantsAvatars() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Jumlah peserta (contoh)
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}