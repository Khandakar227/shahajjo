import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shahajjo/utils/utils.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key, required this.title});
  final String title;

  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  bool isLoading = false;
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
      appBar: MyAppbar(title: widget.title),
      body: SafeArea(
        child: SizedBox(
          height: screenHeight - appBarHeight,
          child: Column(
            children: [
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri("$serverUrl/emergency-contact"),
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    transparentBackground: true,
                  ),
                ),
              ),
              if (isLoading) const LinearProgressIndicator() else Container(),
            ],
          ),
        ),
      ),
    );
  }
}
