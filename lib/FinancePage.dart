import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/Widgets/SummaryCard.dart';
import 'package:flutter_application_idspora/finance/add_budget.dart';
import 'package:flutter_application_idspora/finance/transactionHistory.dart';
import 'package:flutter_application_idspora/finance/index.dart';
import 'package:flutter_application_idspora/finance/add_transaction.dart';
import 'package:flutter_application_idspora/finance/budget_detail_page.dart';
import '../HomeScreen.dart';
import '../TaskPage.dart';
import '../EventsPage.dart';
import '../Widgets/BottomNavigation.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample data
  final List<BudgetItem> _recentBudgets = [
    BudgetItem(
      title: 'Tech Conference 2024',
      date: '2024-01-15 - 09:00:00',
      amount: 150000,
      status: 'Active',
    ),
    BudgetItem(
      title: 'Marketing Campaign Q1',
      date: '2024-02-01 - 10:00:00',
      amount: 85000,
      status: 'Pending',
    ),
  ];

  final List<HistoryItem> _historyItems = [
    HistoryItem(
      title: 'Marketing Campaign Q4',
      date: '2023-12-01',
      amount: 85000,
      status: 'Completed',
    ),
    HistoryItem(
      title: 'Office Equipment Purchase',
      date: '2023-11-15',
      amount: 45000,
      status: 'Completed',
    ),
    HistoryItem(
      title: 'Team Building Event',
      date: '2023-10-20',
      amount: 25000,
      status: 'Completed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildSummaryCards(),
                const SizedBox(height: 32),
                _buildRecentBudgetSection(),
                const SizedBox(height: 32),
                _buildHistorySection(),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: const BottomNavigation(currentRoute: '/finance'),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Finance Page',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A202C),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D3748)),
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
        height: 140,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            SummaryCard(
              title: 'Current Balance',
              value: '175,000',
              icon: Icons.account_balance_wallet_outlined,
              color: const Color(0xFF667EEA), // Purple
            ),
            const SizedBox(width: 16),
            SummaryCard(
              title: 'Total Income',
              value: '8,500,000',
              icon: Icons.trending_up_outlined,
              color: Colors.amber, // Orange/Amber
            ),
            const SizedBox(width: 16),
            SummaryCard(
              title: 'Total Expense',
              value: '675,000',
              icon: Icons.trending_down_outlined,
              color: const Color(0xFF9CA3AF), // Grey
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBudgetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Recent Budget',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: _recentBudgets.length,
          itemBuilder: (context, index) {
            final budget = _recentBudgets[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildBudgetCard(budget),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBudgetCard(BudgetItem budget) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  budget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                    'Edit',
                    Colors.amber,
                    () {
                      // Handle edit
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    'Delete',
                    Colors.red,
                    () {
                      // Handle delete
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            budget.date,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\Rp ${budget.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetDetailPage(budgetItem: budget),
      ),
    );
  },
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.amber[700],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: _historyItems.length,
          itemBuilder: (context, index) {
            final item = _historyItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildHistoryCard(item),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.date} - ${item.status}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
  return FloatingActionButton.extended(
    onPressed: () async {
      // Navigasi ke halaman AddTransaction
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddBudgetPage(
            onBudgetCreated: (budget) {
              // You can handle the new budget here, e.g., refresh the list or show a message
              setState(() {
                // Optionally add the new budget to _recentBudgets or refresh data
              });
            },
          ),
        ),
      );
      if (result == true) {
        setState(() {
          // Refresh data jika perlu
        });
      }
    },
    backgroundColor: Colors.amber,
    foregroundColor: Colors.black,
    elevation: 8,
    icon: const Icon(Icons.add),
    label: const Text(
      'Add Budget',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  );
}
}


class HistoryItem {
  final String title;
  final String date;
  final double amount;
  final String status;

  HistoryItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });
}
