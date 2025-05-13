import 'package:flutter/material.dart';

class EventsRequirements extends StatefulWidget {
  final String eventTitle;

  const EventsRequirements({super.key, required this.eventTitle});

  @override
  State<EventsRequirements> createState() => _EventsRequirementsState();
}

class _EventsRequirementsState extends State<EventsRequirements> {
  // Map untuk melacak status checklist (centang/tidak) pada setiap item di setiap bagian
  final Map<String, Map<String, bool>> _checkedItems = {
    'Peralatan & Logistik': {},
    'Konsumsi': {},
    'Dokumen & Administrasi': {},
    'Tim & SDM': {},
    'Lain-lain': {},
  };

  // Data untuk setiap bagian checklist
  final Map<String, List<String>> _sectionData = {
    'Peralatan & Logistik': [
      'Laptop untuk presentasi',
      'Proyektor dan layar',
      'Sound system (mic, speaker)',
      'Meja registrasi dan kursi',
      'ID card panitia dan peserta',
      'Timer dan bel pengingat waktu',
      'Kamera dokumentasi',
      'Dekorasi (spanduk, backdrop, bunga meja)',
      'Extension kabel/listrik',
    ],
    'Konsumsi': [
      'Air mineral untuk peserta dan panitia',
      'Coffee Break: teh/kopi & snack',
      'Konsumsi MC dan pembicara',
      'Makanan siang panitia (jika full day)',
    ],
    'Dokumen & Administrasi': [
      'Rundown acara tercetak',
      'Absen peserta',
      'Sertifikat (template, nama-nama)',
      'Proposal & laporan kegiatan',
      'Notulen untuk evaluasi',
    ],
    'Tim & SDM': [
      'MC (Stephanie)',
      'Moderator (Alea)',
      'Dokumentasi (Agvin & Maria)',
      'Registrasi peserta (Dini & Arya)',
      'Konsumsi (Fathan)',
      'Sound system & teknis (Arya)',
      'Liaison Officer (untuk pembicara)',
    ],
    'Lain-lain': [
      'Akses Wi-Fi',
      'Kontak darurat',
      'Kotak P3K',
      'Goodie bag / souvenir peserta (opsional)',
    ],
  };

  // Ikon untuk setiap bagian checklist
  final Map<String, IconData> _sectionIcons = {
    'Peralatan & Logistik': Icons.handyman,
    'Konsumsi': Icons.fastfood,
    'Dokumen & Administrasi': Icons.description,
    'Tim & SDM': Icons.people,
    'Lain-lain': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi semua item checklist sebagai belum dicentang (false)
    for (var section in _sectionData.keys) {
      for (var item in _sectionData[section]!) {
        _checkedItems[section]![item] = false;
      }
    }
  }

  // Menghitung progres checklist untuk setiap bagian
  double _getSectionProgress(String section) {
    if (_checkedItems[section]!.isEmpty) return 0.0;
    int total = _checkedItems[section]!.length;
    int checked = _checkedItems[section]!.values.where((v) => v).length;
    return checked / total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requirements',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0E1330),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 241, 236, 219), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan judul acara di dalam kartu
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E1330),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Checklist kebutuhan acara',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Menampilkan progres keseluruhan checklist
                _buildOverallProgress(),
                const SizedBox(height: 24),

                // Menampilkan setiap bagian checklist
                ..._sectionData.keys.map(
                  (section) => _buildRequirementSection(
                    section,
                    _sectionIcons[section]!,
                    const Color(0xFF0E1330),
                    _sectionData[section]!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E1330),
        child: const Icon(Icons.save, color: Colors.white),
        onPressed: () {
          // Fungsi untuk menyimpan checklist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Requirements saved successfully!'),
              backgroundColor: Color(0xFF0E1330),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan progres keseluruhan checklist
  Widget _buildOverallProgress() {
    int totalItems = 0;
    int checkedItems = 0;

    // Menghitung total item dan item yang sudah dicentang
    for (var section in _sectionData.keys) {
      totalItems += _sectionData[section]!.length;
      checkedItems += _checkedItems[section]!.values.where((v) => v).length;
    }

    double progress = totalItems > 0 ? checkedItems / totalItems : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E1330),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Menampilkan indikator progres
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0E1330),
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '$checkedItems of $totalItems items completed',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan setiap bagian checklist
  Widget _buildRequirementSection(
    String title,
    IconData icon,
    Color iconColor,
    List<String> items,
  ) {
    double progress = _getSectionProgress(title);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header bagian checklist
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Menampilkan progres bagian checklist
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),

              // Menampilkan daftar item checklist
              ...items.map((item) => _buildRequirementItem(title, item)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan item checklist
  Widget _buildRequirementItem(String section, String text) {
    bool isChecked = _checkedItems[section]![text] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _checkedItems[section]![text] = !isChecked;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Checkbox untuk setiap item
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                activeColor: const Color(0xFF0E1330),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    _checkedItems[section]![text] = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            // Teks item checklist
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isChecked ? Colors.grey : Colors.black87,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  height: 1.5,
                ),
              ),
            ),
            // Ikon centang jika item sudah dicentang
            if (isChecked)
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}