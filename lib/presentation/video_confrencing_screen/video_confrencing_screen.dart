import 'package:flutter/material.dart';

class VideoConferencingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Conferencing'),
      ),
      body: Center(
        child: Text(
          'Video Conferencing Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
