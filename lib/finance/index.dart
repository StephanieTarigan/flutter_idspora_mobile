import 'package:flutter/material.dart';
import 'transactionHistory.dart';

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
        children: [
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class FinanceIndex extends StatelessWidget {
  const FinanceIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        text: 'Rp. 4,000,000', // Changed currency character
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
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
                    onPressed: () {Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const Transactionhistory(),
                    ));},
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
                      icon: Icons.computer,
                      title: 'Office Equipment',
                      subtitle: 'IT Department',
                      amount: 'Rp.2,450,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.blue,
                    ),
                    TransactionItem(
                      icon: Icons.business,
                      title: 'Office Rent',
                      subtitle: 'Facilities',
                      amount: 'Rp.4,500,000',
                      date: '10 June 2024',
                      iconBgColor: Colors.indigo,
                    ),
                    TransactionItem(
                      icon: Icons.flight,
                      title: 'Business Travel',
                      subtitle: 'Sales Department',
                      amount: 'Rp.1,250,000',
                      date: '08 June 2024',
                      iconBgColor: Colors.teal,
                    ),
                    TransactionItem(
                      icon: Icons.restaurant,
                      title: 'Client Lunch Meeting',
                      subtitle: 'Marketing',
                      amount: 'Rp.180,000',
                      date: '07 June 2024',
                      iconBgColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add the TransactionItem widget as per the original code context