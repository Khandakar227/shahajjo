import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/text_button.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key, required this.title});
  final String title;

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "ইমার্জেন্সি যোগাযোগ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("জরুরী পরিস্থিতির জন্য বিশ্বস্ত পরিচিতি যোগ করুন",
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 20),
                  FullButton(
                    onTap: sendSOS,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.crisis_alert, color: Colors.white),
                        SizedBox(
                          width: 8,
                        ),
                        Text("এস ও এস করুন",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FullButton(
                    onTap: () {},
                    backgroundColor: Colors.black,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(
                          width: 8,
                        ),
                        Text("ইমার্জেন্সি কন্টেক্ট যোগ করুন",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  )
                ]),
          ),
        )));
  }

  void sendSOS() {}
}
