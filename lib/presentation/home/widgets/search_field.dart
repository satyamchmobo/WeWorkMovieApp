import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField(
      {super.key, required this.hint, required this.searchController});

  final String? hint;
  final TextEditingController? searchController;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        controller: widget.searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: widget.hint,
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
    );
  }
}
