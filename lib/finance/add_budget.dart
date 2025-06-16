import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetModel {
  final String eventName;
  final double totalAmount;
  final DateTime createdAt;

  BudgetModel({
    required this.eventName,
    required this.totalAmount,
    required this.createdAt,
  });
}

class AddBudgetPage extends StatefulWidget {
  final Function(BudgetModel) onBudgetCreated;

  const AddBudgetPage({Key? key, required this.onBudgetCreated}) : super(key: key);

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final List<Map<String, TextEditingController>> _categories = [
    {
      'name': TextEditingController(),
      'amount': TextEditingController(text: '0.00'),
    },
  ];

  double get _totalBudget {
    double total = 0.0;
    for (var cat in _categories) {
      final amount = double.tryParse(cat['amount']!.text) ?? 0.0;
      total += amount;
    }
    return total;
  }

  void _addCategory() {
    setState(() {
      _categories.add({
        'name': TextEditingController(),
        'amount': TextEditingController(text: '0.00'),
      });
    });
  }

  void _removeCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    for (var cat in _categories) {
      cat['name']!.dispose();
      cat['amount']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Add Budget'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Event Budget',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Plan your event budget by adding categories and their estimated costs.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Event Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter event name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget Breakdown',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addCategory,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Category'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: Text('Category')),
                    SizedBox(width: 16),
                    SizedBox(width: 100, child: Text('Amount')),
                    SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 8),
                ..._categories.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final cat = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cat['name'],
                            decoration: InputDecoration(
                              hintText: 'Category name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: cat['amount'],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0.00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_categories.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCategory(idx),
                          ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 32, thickness: 1.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      currencyFormat.format(_totalBudget),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_eventNameController.text.isNotEmpty && _totalBudget > 0) {
                            final newBudget = BudgetModel(
                              eventName: _eventNameController.text,
                              totalAmount: _totalBudget,
                              createdAt: DateTime.now(),
                            );
                            widget.onBudgetCreated(newBudget);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: const Text(
                          'Create Event',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}