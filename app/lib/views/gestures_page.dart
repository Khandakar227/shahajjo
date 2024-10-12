import 'package:flutter/material.dart';

class GesturesPage extends StatelessWidget {
  const GesturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Gestures'),
      ),
      body: const Center(
        child: Text('Gestures Page'),
      ),
    );
  }
}