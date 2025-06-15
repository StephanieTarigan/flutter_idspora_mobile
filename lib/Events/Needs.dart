import 'package:flutter/material.dart';

// Model EventTask (jangan import dari file lain)
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
}

// Widget tabel kebutuhan yang telah diperbaiki
class NeedsTable extends StatelessWidget {
  final List<EventTask> tasks;
  
  const NeedsTable({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          _buildTableContent(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada kebutuhan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada kebutuhan yang ditambahkan untuk event ini.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: const Color(0xFF0E1330),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Kebutuhan Event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${tasks.length} items',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 56,
        dataRowHeight: 72,
        horizontalMargin: 20,
        columnSpacing: 24,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        headingRowColor: MaterialStateProperty.all(
          const Color(0xFFF8FAFC),
        ),
        columns: [
          DataColumn(
            label: _buildColumnHeader('Nama Kebutuhan', Icons.title),
          ),
          DataColumn(
            label: _buildColumnHeader('Kategori', Icons.category_outlined),
          ),
          DataColumn(
            label: _buildColumnHeader('Status', Icons.flag_outlined),
          ),
          DataColumn(
            label: _buildColumnHeader('Catatan', Icons.note_outlined),
          ),
        ],
        rows: tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          final isEven = index % 2 == 0;
          
          return DataRow(
            color: MaterialStateProperty.all(
              isEven ? Colors.white : const Color(0xFFFAFAFA),
            ),
            cells: [
              DataCell(_buildTaskTitle(task.title, task.description)),
              DataCell(_buildCategoryChip(task.category)),
              DataCell(_buildStatusBadge(task.status)),
              DataCell(_buildNotesCell(task.approvalNotes)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumnHeader(String title, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF4A5568),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskTitle(String title, String description) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF1A202C),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    Color color;
    
    switch (category) {
      case 'Peralatan & Logistik':
        color = Colors.blue;
        break;
      case 'Konsumsi':
        color = Colors.green;
        break;
      case 'Dokumen & Administrasi':
        color = Colors.purple;
        break;
      case 'Dekorasi':
        color = Colors.pink;
        break;
      case 'Transportasi':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'approved':
        badgeColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'pending':
        badgeColor = Colors.amber;
        icon = Icons.schedule_outlined;
        break;
      case 'rejected':
        badgeColor = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      case 'draft':
        badgeColor = Colors.grey;
        icon = Icons.edit_outlined;
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.help_outline;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: badgeColor,
          ),
          const SizedBox(width: 6),
          Text(
            _capitalizeFirst(status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCell(String? notes) {
    if (notes == null || notes.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'No notes',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Tooltip(
        message: notes,
        child: Text(
          notes,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4A5568),
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

// Widget utama untuk menampilkan kebutuhan dengan header yang lebih baik
class Needs extends StatelessWidget {
  final String eventTitle;
  final List<EventTask> tasks;

  const Needs({
    super.key,
    required this.eventTitle,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeedsTable(tasks: tasks),
        if (tasks.isNotEmpty) _buildSummaryCard(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final approvedCount = tasks.where((task) => task.status.toLowerCase() == 'approved').length;
    final pendingCount = tasks.where((task) => task.status.toLowerCase() == 'pending').length;
    final draftCount = tasks.where((task) => task.status.toLowerCase() == 'draft').length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Approved',
                  approvedCount,
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Pending',
                  pendingCount,
                  const Color(0xFF0E1330),
                  Icons.schedule,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Draft',
                  draftCount,
                  Colors.grey,
                  Icons.edit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}