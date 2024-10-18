import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});
  final String title;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SizedBox(
          height: screenHeight -
              appBarHeight, // Adjust the height to exclude the app bar
          child: const SizedBox(),
        )));
  }
}
