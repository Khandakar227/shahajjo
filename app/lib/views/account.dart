import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/services/auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});
  final String title;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
          child: SizedBox(
            height: screenHeight -
                appBarHeight, // Adjust the height to exclude the app bar
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ProfileWidget(authService.getUser()),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE0014),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        authService.logOut(context);
                      },
                      child: const Text("Log out"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class ProfileWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> user;

  const ProfileWidget(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text("Error loading profile");
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: Container(
                    padding:
                        const EdgeInsets.all(16), // Padding around the text
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFCE0014), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8), // round corners
                    ),
                    child: Text(snapshot.data!['name'])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: Container(
                  padding: const EdgeInsets.all(16), // Padding around the text
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFCE0014), // Border color
                    ),
                    borderRadius: BorderRadius.circular(8), // round corners
                  ),
                  child: Text(snapshot.data!['phoneNumber']),
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
