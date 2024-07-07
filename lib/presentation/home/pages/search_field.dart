import 'package:flutter/material.dart';

class SearchField extends SliverPersistentHeaderDelegate {
  final Function(String) onTextChanged;
  final TextEditingController? controller;

  SearchField({
    required this.onTextChanged,
    required this.controller,
  });

  @override
  double get minExtent => 60.0; // Adjust as needed

  @override
  double get maxExtent => 60.0; // Adjust as needed

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(30),
        child: TextFormField(
          onChanged: onTextChanged,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: 'Search Movies by name...',
            hintStyle: const TextStyle(
                fontSize: 15.0,
                color: Color(0xffA9A9A9),
                fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SearchField oldDelegate) {
    return false;
  }
}
