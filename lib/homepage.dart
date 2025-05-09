import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Testing Title",
          style: TextStyle(
            color: Colors.green,
          ),
          )
        )
      );
  }
}

// This is from Zhu XP branch
// This is from Memo branch