import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String optionText;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.optionText,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
      }
    }

    return InkWell(
      onTap: isAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isAnswered
                  ? (isCorrect ? Colors.green : (isSelected ? Colors.red : Colors.grey))
                  : Theme.of(context).colorScheme.primary,
              child: Text(
                String.fromCharCode(65 + index),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                optionText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (isAnswered && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
            if (isAnswered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}