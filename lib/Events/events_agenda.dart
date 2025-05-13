import 'package:flutter/material.dart';

// Widget utama untuk menampilkan agenda acara
class EventsAgenda extends StatelessWidget {
  final String eventTitle; // Judul acara yang akan ditampilkan

  const EventsAgenda({super.key, required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menampilkan judul halaman dengan nama acara
        title: Text('Agenda for $eventTitle'),
        backgroundColor: const Color(0xFF0E1330), // Warna latar belakang AppBar
        foregroundColor: Colors.white, // Warna teks di AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding untuk konten
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan judul acara
              Text(
                eventTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Jarak antar elemen

              // Menampilkan detail acara seperti tanggal, tempat, MC, dan pembicara
              _buildEventDetail(Icons.calendar_today, 'Tanggal: Minggu, 4 Mei 2025'),
              _buildEventDetail(Icons.location_on, 'Tempat: Gedung FIT, Telkom University'),
              _buildEventDetail(Icons.mic, 'MC: Stephanie'),
              _buildEventDetail(Icons.record_voice_over, 'Pembicara: Arya'),

              const SizedBox(height: 24), // Jarak sebelum rundown

              // Judul untuk bagian rundown acara
              const Row(
                children: [
                  Icon(Icons.schedule, color: Color(0xFF0E1330)), // Ikon rundown
                  SizedBox(width: 8),
                  Text(
                    'Rundown Acara',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16), // Jarak sebelum daftar rundown

              // Daftar rundown acara
              _buildRundownItem('07.00 - 08.00', 'Persiapan Panitia', 'Dekorasi, Soundcheck, Setup meja registrasi'),
              _buildRundownItem('08.00 - 08.30', 'Registrasi Peserta', 'oleh tim registrasi'),
              _buildRundownItem('08.30 - 08.45', 'Pembukaan oleh MC', 'Stephanie'),
              _buildRundownItem('08.45 - 09.00', 'Sambutan Ketua Pelaksana', 'Fathan'),
              _buildRundownItem('09.00 - 10.30', 'Sesi 1: Pengenalan UI/UX dan Figma', 'Pembicara: Arya'),
              _buildRundownItem('10.30 - 10.45', 'Ice Breaking', 'Games oleh Dini & Alea'),
              _buildRundownItem('10.45 - 11.00', 'Coffee Break', ''),
              _buildRundownItem('11.00 - 12.30', 'Sesi 2: Workshop Hands-On Figma', 'Dibimbing oleh Maria'),
              _buildRundownItem('12.30 - 12.45', 'Tanya Jawab', ''),
              _buildRundownItem('12.45 - 13.00', 'Penutupan dan Pengumuman Best Participant', ''),
              _buildRundownItem('13.00 - 13.15', 'Foto Bersama', ''),
              _buildRundownItem('13.15 - 14.00', 'Evaluasi Panitia', 'internal, opsional'),
              _buildRundownItem('14.00 - 15.00', 'Beres-beres dan Check-Out', ''),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail acara (ikon + teks)
  Widget _buildEventDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Jarak antar detail
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]), // Ikon detail
          const SizedBox(width: 8), // Jarak antara ikon dan teks
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800], // Warna teks
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan item rundown acara
  Widget _buildRundownItem(String time, String activity, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Jarak antar rundown
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200), // Border rundown
        borderRadius: BorderRadius.circular(8), // Sudut border
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Padding dalam rundown
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom waktu rundown
            Container(
              width: 100, // Lebar kolom waktu
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1330).withOpacity(0.1), // Warna latar waktu
                borderRadius: BorderRadius.circular(4), // Sudut border waktu
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12), // Jarak antara waktu dan detail

            // Kolom detail aktivitas rundown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama aktivitas
                  Text(
                    activity,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // Detail tambahan (jika ada)
                  if (details.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        details,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600], // Warna teks detail
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}