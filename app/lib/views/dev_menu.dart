import 'package:flutter/material.dart';

class DevMenu extends StatelessWidget {
  const DevMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: const Text('Button'), // Added missing child parameter
            ),
          ],
        ),
      ),
    );
  }
}
