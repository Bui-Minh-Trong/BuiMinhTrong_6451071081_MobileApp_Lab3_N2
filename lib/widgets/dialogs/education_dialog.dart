import 'package:flutter/material.dart';
import '../dialog_text_field.dart';

class EducationDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const EducationDialog({super.key, this.initialData});

  @override
  State<EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends State<EducationDialog> {
  late final TextEditingController _degreeController;
  late final TextEditingController _schoolController;
  late final TextEditingController _periodController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['degree'] : '',
    );
    _schoolController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['school'] : '',
    );
    _periodController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['period'] : '',
    );
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _schoolController.dispose();
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
              isEdit ? 'Edit Education' : 'Add Education',
              style: const TextStyle(
                color: Color(0xFF130160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _degreeController,
              label: 'Degree / Program',
              hintText: 'e.g. Information Technology',
            ),
            DialogTextField(
              controller: _schoolController,
              label: 'School / University',
              hintText: 'e.g. University of Oxford',
            ),
            DialogTextField(
              controller: _periodController,
              label: 'Period & Duration',
              hintText: 'e.g. Sep 2010 - Aug 2013 · 5 Years',
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
                      final degree = _degreeController.text.trim();
                      final school = _schoolController.text.trim();
                      final period = _periodController.text.trim();
                      if (degree.isNotEmpty && school.isNotEmpty) {
                        Navigator.pop(context, {
                          'degree': degree,
                          'school': school,
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
