import 'package:flutter/material.dart';

class CustomTextSeperator extends StatelessWidget {
  final String title;

  const CustomTextSeperator({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.8),
                  Colors.grey.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
