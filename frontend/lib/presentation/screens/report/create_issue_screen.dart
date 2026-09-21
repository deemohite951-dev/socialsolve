import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/issue_service.dart';

class CreateIssueScreen extends StatefulWidget {
  const CreateIssueScreen({super.key});

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCategory = 'roads';
  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = [
    {'value': 'roads', 'label': 'Roads & Infrastructure'},
    {'value': 'sanitation', 'label': 'Garbage & Sanitation'},
    {'value': 'water', 'label': 'Water Supply'},
    {'value': 'electricity', 'label': 'Electricity & Power'},
    {'value': 'other', 'label': 'Other'},
  ];

  void _submitIssue() async {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final formData = FormData.fromMap({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'location': _locationController.text.trim(),
        'category': _selectedCategory,
      });

      await IssueService().createIssue(formData);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit issue. Please check login.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Report an Issue', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Center(
        child: Container(
          width: 550,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: const InputDecoration(labelText: 'Issue Title *'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((c) {
                    return DropdownMenuItem(value: c['value'], child: Text(c['label']!));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _locationController,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: const InputDecoration(labelText: 'Location / Landmark *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitIssue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit Report', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}