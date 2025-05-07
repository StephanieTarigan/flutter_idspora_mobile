import 'package:flutter/material.dart';
import '../financePage.dart';
import 'add_transaction.dart';

class Transactionhistory extends StatelessWidget {
  const Transactionhistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Header with Company Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Transaction History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.search),
                ],
              ),
              const SizedBox(height: 24),

              // Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'All Departments',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction List
              Expanded(
                child: ListView(
                  children: const [
                    TransactionItem(
                      icon: Icons.computer,
                      title: 'Office Equipment',
                      subtitle: 'IT Department',
                      amount: '\Rp.2,450,000',
                      date: '12 June 2024',
                      iconBgColor: Colors.blue,
                    ),
                    TransactionItem(
                      icon: Icons.business,
                      title: 'Office Rent',
                      subtitle: 'Facilities',
                      amount: '\Rp.4,500,000',
                      date: '10 June 2024',
                      iconBgColor: Colors.indigo,
                    ),
                    TransactionItem(
                      icon: Icons.flight,
                      title: 'Business Travel',
                      subtitle: 'Sales Department',
                      amount: '\Rp.1,250,000',
                      date: '08 June 2024',
                      iconBgColor: Colors.teal,
                    ),
                    TransactionItem(
                      icon: Icons.restaurant,
                      title: 'Client Lunch Meeting',
                      subtitle: 'Marketing',
                      amount: '\Rp.180,000',
                      date: '07 June 2024',
                      iconBgColor: Colors.orange,
                    ),
                    TransactionItem(
                      icon: Icons.inventory,
                      title: 'Office Supplies',
                      subtitle: 'Administration',
                      amount: '\Rp.320,000',
                      date: '05 June 2024',
                      iconBgColor: Colors.grey,
                    ),
                    TransactionItem(
                      icon: Icons.subscriptions,
                      title: 'Software Subscriptions',
                      subtitle: 'IT Department',
                      amount: '\Rp.750,000',
                      date: '01 June 2024',
                      iconBgColor: Colors.purple,
                    ),
                    TransactionItem(
                      icon: Icons.event,
                      title: 'Conference Registration',
                      subtitle: 'HR Department',
                      amount: '\Rp.500,000',
                      date: '28 May 2024',
                      iconBgColor: Colors.red,
                    ),
                    TransactionItem(
                      icon: Icons.local_shipping,
                      title: 'Shipping Costs',
                      subtitle: 'Logistics',
                      amount: '\Rp.175,000',
                      date: '25 May 2024',
                      iconBgColor: Colors.brown,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button with elevated effect
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: const EdgeInsets.only(bottom: 15, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Addtransaction(),
              ),
            );
          },
          backgroundColor: Colors.blue[800],
          elevation: 8, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}