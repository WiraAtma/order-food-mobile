import 'dart:async';

import 'package:flutter/material.dart';

class HomeSearchbarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const HomeSearchbarWidget({super.key, required this.onChanged});

  @override
  State<HomeSearchbarWidget> createState() => _HomeSearchbarWidgetState();
}

class _HomeSearchbarWidgetState extends State<HomeSearchbarWidget> {
  Timer? debounce;

  void onChanged(String value) {
    debounce?.cancel();
    debounce = Timer(Duration(seconds: 1), () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Search",
                prefixIcon: Icon(Icons.search, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
