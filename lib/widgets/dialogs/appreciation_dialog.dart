import 'package:flutter/material.dart';
import '../dialog_text_field.dart';

class AppreciationDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const AppreciationDialog({super.key, this.initialData});

  @override
  State<AppreciationDialog> createState() => _AppreciationDialogState();
}

class _AppreciationDialogState extends State<AppreciationDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _awarderController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['title'] : '',
    );
    _awarderController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['awarder'] : '',
    );
    _yearController = TextEditingController(
      text: widget.initialData != null ? widget.initialData!['year'] : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _awarderController.dispose();
    _yearController.dispose();
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
              isEdit ? 'Edit Appreciation' : 'Add Appreciation',
              style: const TextStyle(
                color: Color(0xFF130160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _titleController,
              label: 'Award / Honor Title',
              hintText: 'e.g. Wireless Symposium (RWS)',
            ),
            DialogTextField(
              controller: _awarderController,
              label: 'Awarder / Organizer',
              hintText: 'e.g. Young Scientist',
            ),
            DialogTextField(
              controller: _yearController,
              label: 'Year',
              hintText: 'e.g. 2014',
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
                      final title = _titleController.text.trim();
                      final awarder = _awarderController.text.trim();
                      final year = _yearController.text.trim();
                      if (title.isNotEmpty) {
                        Navigator.pop(context, {
                          'title': title,
                          'awarder': awarder,
                          'year': year,
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
