import 'package:flutter/material.dart';
import '../dialog_text_field.dart';

class WorkExpDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const WorkExpDialog({super.key, this.initialData});

  @override
  State<WorkExpDialog> createState() => _WorkExpDialogState();
}

class _WorkExpDialogState extends State<WorkExpDialog> {
  late final TextEditingController _roleController;
  late final TextEditingController _companyController;
  late final TextEditingController _periodController;

  @override
  void initState() {
    super.initState();
    _roleController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['role'] : '',
    );
    _companyController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['company'] : '',
    );
    _periodController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['period'] : '',
    );
  }

  @override
  void dispose() {
    _roleController.dispose();
    _companyController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'Edit Work Experience' : 'Add Work Experience',
              style: const TextStyle(
                color: Color(0xFF130160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _roleController,
              label: 'Role',
              hintText: 'e.g. Manager',
            ),
            DialogTextField(
              controller: _companyController,
              label: 'Company',
              hintText: 'e.g. Amazon Inc',
            ),
            DialogTextField(
              controller: _periodController,
              label: 'Period & Duration',
              hintText: 'e.g. Jan 2015 - Feb 2022 · 5 Years',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF130160),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final role = _roleController.text.trim();
                      final company = _companyController.text.trim();
                      final period = _periodController.text.trim();
                      if (role.isNotEmpty && company.isNotEmpty) {
                        Navigator.pop(context, {
                          'role': role,
                          'company': company,
                          'period': period,
                        });
                      }
                    },
                    child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF130160),
                      side: const BorderSide(color: Color(0xFF130160)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
