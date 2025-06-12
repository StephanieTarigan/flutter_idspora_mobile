import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_idspora/controller/EventController.dart';
import 'package:flutter_application_idspora/models/Event.dart';
import 'package:intl/intl.dart';

import 'taskpage.dart';
import 'eventspage.dart';
import 'financepage.dart';
import 'Events/EventDetailsPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  
  // Data variables
  List<Event> _events = [];
  bool _isLoading = true;
  String _userName = 'Stephanie'; // This should come from user profile API
  
  // Statistics
  int _upcomingEventsCount = 0;
  Event? _nextUpcomingEvent;

  @override
  void initState() {
    super.initState();
    _loadEventsData();
  }

  Future<void> _loadEventsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final events = await EventController.fetchEvents();
      final now = DateTime.now();
      
      // Filter upcoming events
      final upcomingEvents = events.where((event) {
        try {
          final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
          return eventDate.isAfter(now) || eventDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
        } catch (e) {
          return false;
        }
      }).toList();

      // Sort by date to get the next upcoming event
      upcomingEvents.sort((a, b) {
        try {
          final dateA = DateFormat('yyyy-MM-dd').parse(a.date);
          final dateB = DateFormat('yyyy-MM-dd').parse(b.date);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        _events = events;
        _upcomingEventsCount = upcomingEvents.length;
        _nextUpcomingEvent = upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
      });
    } catch (e) {
      _showSnackbar('Error loading events: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  String _getTimeLeft(Event event) {
    try {
      final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
      final now = DateTime.now();
      final difference = eventDate.difference(now).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference > 1) {
        return '$difference Days Left';
      } else {
        return 'Past Event';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _onNavigationItemTapped(int index) {
    if (index != _selectedIndex) {
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventsPage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FinancePage()),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadEventsData,
          color: Colors.orange,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildGreeting(),
                _buildSummaryCards(),
                _buildUpcomingEvents(),
                _buildUpcomingTasks(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
              image: const DecorationImage(
                image: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $_userName',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s a quick overview of idspora activities.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Summary cards dengan data Events dari API dan data dummy untuk Task & Finance
  Widget _buildSummaryCards() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // Data dari API Events
          SummaryCard(
            title: 'Upcoming Events',
            value: _isLoading ? '...' : _upcomingEventsCount.toString(),
            icon: Icons.event,
            color: const Color(0xFF0E1330),
          ),
          const SizedBox(width: 12),
          // Data dummy untuk Tasks
          const SummaryCard(
            title: 'Unfinished Tasks',
            value: '20',
            icon: Icons.task_alt,
            color: const Color(0xFF0E1330),
          ),
          const SizedBox(width: 12),
          // Data dummy untuk Finance
          const SummaryCard(
            title: 'Monthly Expenses',
            value: 'Rp 2.5M',
            icon: Icons.bar_chart,
            color: const Color(0xFF0E1330),
          ),
          const SizedBox(width: 12),
          const SummaryCard(
            title: 'Monthly Income',
            value: 'Rp 5.8M',
            icon: Icons.account_balance_wallet,
            color: const Color(0xFF0E1330),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Upcoming Events dari API Database
  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Upcoming Events'),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ),
          )
        else if (_nextUpcomingEvent != null)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(event: _nextUpcomingEvent!),
                ),
              ).then((result) {
                // Refresh events jika ada perubahan
                if (result == true) {
                  _loadEventsData();
                }
              });
            },
            child: EventCard(
              title: _nextUpcomingEvent!.title,
              category: _nextUpcomingEvent!.category,
              progress: 0.50, // Progress bisa dihitung berdasarkan status event
              progressText: '50%',
              timeLeft: _getTimeLeft(_nextUpcomingEvent!),
              imagePath: 'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No upcoming events',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventsPage()),
                        ).then((result) {
                          if (result == true) {
                            _loadEventsData();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View All Events'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Upcoming Tasks tetap menggunakan data dummy
  Widget _buildUpcomingTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Upcoming Task'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Task Today',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        // Task card - Data dummy
        const TaskCard(
          title: 'Creating Awesome Mobile Apps',
          category: 'UI/UX Designer',
          progress: 0.75,
          progressText: '75%',
          timeLeft: '1 Hour',
          imagePath: 'https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Task',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'UI/UX Designer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Task detail items - Data dummy
        const TaskDetailItem(number: 1, text: 'Tentukan tanggal, waktu, dan durasi'),
        const TaskDetailItem(number: 2, text: 'Tentukan MC dan Narasumber'),
        const TaskDetailItem(number: 3, text: 'Buat poster & konten promosi'),
        const TaskDetailItem(number: 4, text: 'Buat dan sebar Google Form/website untuk pendaftaran'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F6AF6),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Go To Detail',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBottomNavigation() {
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
              _buildNavItem(0, Icons.home, 'Home', true),
              _buildNavItem(1, Icons.task, 'Task', false),
              _buildNavItem(2, Icons.event, 'Event', false),
              _buildNavItem(3, Icons.account_balance_wallet, 'Finance', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        _onNavigationItemTapped(index);
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

// Widget components tetap sama
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String category;
  final double progress;
  final String progressText;
  final String timeLeft;
  final String imagePath;

  const EventCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.progressText,
    required this.timeLeft,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                progressText,
                style: const TextStyle(
                  color: Color(0xFF4F6AF6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F6AF6)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeLeft,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              _buildTeamAvatars(),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTeamAvatars() {
    return SizedBox(
      width: 80,
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < 5; i++)
            Positioned(
              left: i * 15.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final double progress;
  final String progressText;
  final String timeLeft;
  final String imagePath;

  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.progressText,
    required this.timeLeft,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                progressText,
                style: const TextStyle(
                  color: Color(0xFF4F6AF6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F6AF6)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeLeft,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              _buildTeamAvatars(),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTeamAvatars() {
    return SizedBox(
      width: 80,
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < 5; i++)
            Positioned(
              left: i * 15.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage('https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TaskDetailItem extends StatelessWidget {
  final int number;
  final String text;

  const TaskDetailItem({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
