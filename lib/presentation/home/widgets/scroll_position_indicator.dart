import 'package:flutter/material.dart';

class ScrollPositionIndicator extends StatelessWidget {
  const ScrollPositionIndicator({
    super.key,
    required int currentIndex,
    required int length,
  })  : _currentIndex = currentIndex,
        _length = length;

  final int _currentIndex;
  final int _length;

  @override
  Widget build(BuildContext context) {
    return _getIndicator();
  }

  Widget _getIndicator() {
    if (_currentIndex + 1 >= 1 && _currentIndex < (_length / 2).toInt()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1}/$_length',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
    if (_currentIndex + 1 == (_length / 2).toInt()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1}/$_length',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
    if (_currentIndex + 1 > (_length / 2).toInt() &&
        _currentIndex + 1 <= _length) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1}/$_length',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
