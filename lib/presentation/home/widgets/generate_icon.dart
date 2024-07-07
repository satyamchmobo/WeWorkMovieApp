import 'package:flutter/material.dart';

Widget iconGenerate(String? imagePath, bool isSelected, IconData icon) {
  return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? Colors.black : Colors.transparent,
    ),
    child: imagePath != null
        ? Image.asset(
            imagePath,
            width: 22,
            height: 22,
            color: isSelected ? Colors.white : Colors.grey,
          )
        : Icon(
            icon,
            size: 22,
            color: isSelected ? Colors.white : Colors.grey,
          ),
  );
}
