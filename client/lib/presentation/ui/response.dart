import 'package:flutter/material.dart';

class ResponsePage extends StatelessWidget {
  final dynamic responseData;
  const ResponsePage({super.key, required this.responseData, required String responseText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Response Page')),
      body: Center(
        child: Text(
          'Server Response: ${responseData.toString()}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
