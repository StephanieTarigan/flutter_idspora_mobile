import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;
  final dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  void _updateTaskStatus(TaskStatus newStatus) {
    double newProgress = _task.progress;
    
    // Update progress based on new status
    if (newStatus == TaskStatus.done) {
      newProgress = 1.0;
    } else if (newStatus == TaskStatus.inProgress && _task.status == TaskStatus.todo) {
      newProgress = 0.5;
    } else if (newStatus == TaskStatus.todo) {
      newProgress = 0.0;
    }
    
    setState(() {
      _task = _task.copyWith(
        status: newStatus,
        progress: newProgress,
      );
    });
    
    // Update the task in the global list
    final index = globalTasks.indexWhere((t) => t.id == _task.id);
    if (index != -1) {
      globalTasks[index] = _task;
    }
    
    Navigator.pop(context, _task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF272B4A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF272B4A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _task),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/44.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Text(
              'Task Details',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskHeader(),
                    const SizedBox(height: 24),
                    _buildProgressSection(),
                    const SizedBox(height: 24),
                    _buildDescriptionSection(),
                    const SizedBox(height: 24),
                    _buildDetailsSection(),
                    const SizedBox(height: 24),
                    _buildPrioritySection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildTaskHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: _task.status.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _task.status.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 20,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              _task.assignedTo,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(_task.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _task.status.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _task.progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_task.status.color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            _task.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    final daysLeft = _task.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0 && _task.status != TaskStatus.done;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Due Date',
            dateFormat.format(_task.dueDate),
            Icons.calendar_today,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            'Time Remaining',
            isOverdue 
                ? 'Overdue by ${-daysLeft} day${-daysLeft != 1 ? 's' : ''}' 
                : _task.status == TaskStatus.done 
                    ? 'Completed' 
                    : '$daysLeft day${daysLeft != 1 ? 's' : ''} left',
            Icons.access_time,
            textColor: isOverdue ? Colors.red : null,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            'Created',
            dateFormat.format(DateTime.now().subtract(const Duration(days: 5))),
            Icons.create,
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    String priorityText;
    Color priorityColor;
    
    switch (_task.priority) {
      case 3:
        priorityText = 'High Priority';
        priorityColor = Colors.red;
        break;
      case 2:
        priorityText = 'Medium Priority';
        priorityColor = Colors.orange;
        break;
      default:
        priorityText = 'Low Priority';
        priorityColor = Colors.green;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priorityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flag_rounded,
            color: priorityColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            priorityText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: priorityColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String content, IconData icon, {Color? textColor}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}