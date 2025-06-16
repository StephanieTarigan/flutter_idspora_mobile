import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_idspora/Finance/add_transaction.dart';

class BudgetDetailPage extends StatefulWidget {
  final BudgetItem budgetItem;

  const BudgetDetailPage({super.key, required this.budgetItem});

  @override
  State<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample detailed data
  final List<TransactionDetail> _transactions = [
    TransactionDetail(
      category: 'Event',
      description: 'Venue booking for main conference hall',
      amount: 75000,
      date: '2024-01-10',
      status: 'Paid',
    ),
    TransactionDetail(
      category: 'Operasional',
      description: 'Audio visual equipment rental',
      amount: 35000,
      date: '2024-01-12',
      status: 'Paid',
    ),
    TransactionDetail(
      category: 'Other',
      description: 'Marketing materials and banners',
      amount: 25000,
      date: '2024-01-14',
      status: 'Pending',
    ),
    TransactionDetail(
      category: 'Event',
      description: 'Catering for 200 participants',
      amount: 15000,
      date: '2024-01-15',
      status: 'Pending',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.amber.shade800,
      ),
    );
  }

  void _editBudget() {
    _showSnackbar('Edit budget functionality');
  }

  void _deleteBudget() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Delete Budget',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete "${widget.budgetItem.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      _showSnackbar('Budget deleted successfully');
      Navigator.pop(context, true);
    }
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
                _buildBudgetHeader(),
                const SizedBox(height: 24),
                _buildSummarySection(),
                const SizedBox(height: 32),
                _buildTransactionSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
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
        'Budget Details',
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
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
            onPressed: () {
              _showOptionsBottomSheet();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                  widget.budgetItem.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.budgetItem.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.budgetItem.date,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rp ${widget.budgetItem.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final totalPaid = _transactions
        .where((t) => t.status == 'Paid')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalPending = _transactions
        .where((t) => t.status == 'Pending')
        .fold(0.0, (sum, t) => sum + t.amount);
    final remaining = widget.budgetItem.amount - totalPaid - totalPending;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Paid',
                  totalPaid,
                  Colors.green,
                  Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Pending',
                  totalPending,
                  Colors.orange,
                  Icons.schedule_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Remaining',
                  remaining,
                  Colors.blue,
                  Icons.account_balance_wallet_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Addtransaction(),
                    ),
                  );
                  if (result == true) {
                    setState(() {
                      // Refresh data jika perlu
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTransactionCard(transaction),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionDetail transaction) {
    Color statusColor;
    IconData statusIcon;

    switch (transaction.status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_rounded;
    }

    Color categoryColor;
    switch (transaction.category.toLowerCase()) {
      case 'event':
        categoryColor = Colors.blue;
        break;
      case 'operasional':
        categoryColor = Colors.purple;
        break;
      case 'other':
        categoryColor = Colors.teal;
        break;
      default:
        categoryColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaction.category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    transaction.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            transaction.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.date,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                'Rp ${transaction.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.amber),
                  ),
                  title: const Text('Edit Budget'),
                  onTap: () {
                    Navigator.pop(context);
                    _editBudget();
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text('Delete Budget'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteBudget();
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.share_outlined, color: Colors.blue),
                  ),
                  title: const Text('Share Budget'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnackbar('Share functionality');
                  },
                ),
              ],
            ),
          ),
    );
  }
}

// Data model for transaction details
class TransactionDetail {
  final String category;
  final String description;
  final double amount;
  final String date;
  final String status;

  TransactionDetail({
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });
}

// Update the existing BudgetItem class if needed
class BudgetItem {
  final String title;
  final String date;
  final double amount;
  final String status;

  BudgetItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });
}
