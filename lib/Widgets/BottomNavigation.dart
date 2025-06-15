import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final String currentRoute;

  const BottomNavigation({
    super.key,
    required this.currentRoute,
  });

  // Mendapatkan index tab aktif berdasarkan currentRoute
  int _getCurrentIndex() {
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/task':
        return 1;
      case '/event':
        return 2;
      case '/finance':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomNavigation(context);
  }

  // Widget utama bottom navigation custom
  Widget _buildBottomNavigation(BuildContext context) {
    final selectedIndex = _getCurrentIndex(); // index tab aktif
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
              // Setiap tab, isSelected true jika index == selectedIndex
              _buildNavItem(context, 0, Icons.home, 'Home', selectedIndex == 0),
              _buildNavItem(context, 1, Icons.task, 'Task', selectedIndex == 1),
              _buildNavItem(context, 2, Icons.event, 'Event', selectedIndex == 2),
              _buildNavItem(context, 3, Icons.account_balance_wallet, 'Finance', selectedIndex == 3),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk setiap item/tab di bottom navigation
  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        // Navigasi hanya jika tab belum aktif
        if (!isSelected) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/task');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/event');
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
          color: isSelected ? Colors.amber : Colors.transparent, // Tab aktif kuning
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey, // Icon aktif hitam, nonaktif abu
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