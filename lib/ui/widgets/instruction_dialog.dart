import 'package:flutter/material.dart';

class InstructionDialog extends StatelessWidget {
  const InstructionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('How to Set Wallpaper'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInstructionStep('1. Go to your device Settings'),
            _buildInstructionStep('2. Find "Wallpaper" or "Display"'),
            _buildInstructionStep('3. Tap "Change Wallpaper"'),
            _buildInstructionStep('4. Choose "Gallery" or "Photos"'),
            _buildInstructionStep('5. Select this image'),
            _buildInstructionStep('6. Adjust and set as wallpaper'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tip: The image is saved in your gallery. '
                    'You can find it in your photos app.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it!'),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}