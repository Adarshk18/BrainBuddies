import 'package:flutter/material.dart';

class StudyMaterialsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Materials'),
      ),
      body: Center(
        child: Text(
          'Study Materials List',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
