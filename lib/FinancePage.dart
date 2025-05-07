import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'TaskPage.dart';
import 'EventsPage.dart';
import 'finance/transactionHistory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/task': (context) => const TaskPage(),
        '/event': (context) => const EventsPage(),
        '/finance': (context) => const FinancePage(),
      },
    );
  }
}

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: Colors.blue, // Warna header
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\Rp. 4,000,000', // Total balance
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(
                        text: ',00',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Expense & Income Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Handle Expense button tap
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Colors.red[300],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expense',
                              style: TextStyle(
                                color: Colors.red[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Handle Income button tap
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_circle_down_outlined,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Income',
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const Transactionhistory(),
                        )
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Transaction List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    TransactionItem(
                      icon: Icons.shopping_cart,
                      title: 'Supermarket',
                      subtitle: 'Groceries',
                      amount: '\Rp.210,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.amber,
                    ),
                    TransactionItem(
                      icon: Icons.home,
                      title: 'Monthly Rent Payment',
                      subtitle: 'Rent / Mortgage',
                      amount: '\Rp.2,100,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.orange,
                    ),
                    TransactionItem(
                      icon: Icons.flash_on,
                      title: 'Electricity Bill',
                      subtitle: 'Utilities',
                      amount: '\Rp.120,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.yellow,
                    ),
                    TransactionItem(
                      icon: Icons.directions_bus,
                      title: 'Public Transit Pass',
                      subtitle: 'Transportation',
                      amount: '\Rp.180,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.green,
                    ),
                    TransactionItem(
                      icon: Icons.shopping_basket,
                      title: 'Online Grocery Delivery',
                      subtitle: 'Groceries',
                      amount: '\Rp.72,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

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
              _buildNavItem(context, 2, Icons.event, 'Event', false),
              _buildNavItem(context, 3, Icons.account_balance_wallet, 'Finance', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TaskPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const EventsPage()),
              );
              break;
            case 3:
              // Already on finance page
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

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final Color iconBgColor;

  const TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.iconBgColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconBgColor.withOpacity(0.2),
        child: Icon(icon, color: iconBgColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}