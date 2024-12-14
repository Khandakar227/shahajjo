import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/utils/utils.dart';

final webViewKey = GlobalKey<_MapState>();
const defaultCenter = {"lng": 90.40662455502002, "lat": 23.8002302959404};

class IncidentMap extends StatefulWidget {
  const IncidentMap({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<IncidentMap> {
  InAppWebViewController? webViewController;
  LocationService locationService = LocationService();
  Position? position;
  String fullUrl = "$serverUrl/incident-monitor?device=mobile";
  int _stackIndex = 1;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (!mounted) return;
      setState(() {
        if (status == ServiceStatus.enabled) {
          initPosition();
        }
      });
    });

    initPosition();
  }

  void initPosition() {
    locationService.getCurrentLocation().then((p) {
      setState(() {
        position = p;
        fullUrl =
            "$serverUrl?device=mobile&lat=${p.latitude}&lng=${p.longitude}";
      });
      webViewController!
          .loadUrl(urlRequest: URLRequest(url: WebUri.uri(Uri.parse(fullUrl))));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        IndexedStack(
          index: _stackIndex,
          children: [
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(fullUrl))),
              initialSettings: InAppWebViewSettings(
                  clearCache: true, geolocationEnabled: true),
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                  origin: origin,
                  allow: true,
                  retain: true,
                );
              },
              onConsoleMessage: (controller, consoleMessage) {
                logger.d(consoleMessage.message);
              },
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
              },
              onLoadStart: (controller, url) {
                logger.d("Load start");
                setState(() {
                  _stackIndex = 1;
                });
              },
              onLoadStop: (controller, url) async {
                logger.d("Load stop");
                if (!hasError) {
                  setState(() {
                    _stackIndex = 0;
                    webViewController = controller;
                  });
                }
              },
              onReceivedError: (controller, request, error) {
                logger.e("onRecieveError: $error");
                if (error.type == WebResourceErrorType.UNKNOWN) return;
                setState(() {
                  _stackIndex = 2;
                  hasError = true;
                });
              },
              onReceivedHttpError: (controller, request, errorResponse) {
                logger.e("onReceivedHttpError: ${errorResponse.statusCode}");
              },
            ),
            const LoadingScreen(),
            ErrorWidget(reload: reload),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: CircleAvatar(
                  backgroundColor: Colors.brown[800],
                  radius: 20,
                  child: IconButton(
                    onPressed: () {
                      webViewController?.loadUrl(
                          urlRequest:
                              URLRequest(url: WebUri.uri(Uri.parse(fullUrl))));
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.white,
                    ),
                  ))),
        ),
      ]),
    );
  }

  void reload() {
    webViewController?.reload();
    setState(() {
      _stackIndex = 1;
      hasError = false;
    });
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()]));
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.reload,
  });

  final Function? reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red[900], size: 64),
          const SizedBox(height: 16),
          const Text(
            "Oops! Something went wrong.",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please check your connection or try again later.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              reload!();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
