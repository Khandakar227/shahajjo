import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // Center widget to align elements
          child: ListView(
            shrinkWrap: true, // Ensures ListView shrinks to its content
            children: const [
              AndroidLarge1(),
            ],
          ),
        ),
      ),
    );
  }
}

class AndroidLarge1 extends StatelessWidget {
  const AndroidLarge1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centers everything vertically
      children: [
        Container(
          width: MediaQuery.of(context).size.width *
              0.8, // 80% of the screen width
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center all elements in the column
            children: [
              // App Logo
              Container(
                width: MediaQuery.of(context).size.width *
                    0.4, // 40% of the screen width
                height: MediaQuery.of(context).size.width *
                    0.4, // Making height equal to width
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/AppLogoTransparent.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // Space between logo and welcome text

              // Welcome Text
              Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFCE0014),
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // Space between welcome and email section

              // Email Section
              Column(
                // Change Row to Column
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align label to the start (left)
                children: [
                  Text(
                    'Email:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height *
                          0.015, // Smaller font size
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.01), // Space between label and text field
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height *
                        0.045, // Reduced height
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDDDDDD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const TextField(
                      cursorColor: Color(0xFFCE0014),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Smaller text size
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // Dynamic space

              // Password Section
              Column(
                // Change Row to Column
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align label to the start (left)
                children: [
                  Text(
                    'Password:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height *
                          0.015, // Smaller font size
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.01), // Space between label and text field
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height *
                        0.045, // Reduced height
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDDDDDD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const TextField(
                      obscureText: true,
                      cursorColor: Color(0xFFCE0014),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Smaller text size
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.01), // Dynamic space

              // Forgot Password aligned to the right
              Align(
                alignment: Alignment.centerRight, // Align to the right
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFFCE0014),
                    fontSize: 12,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Dynamic space

              // Login Button
              GestureDetector(
                onTap: () {
                  // Handle login action
                },
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.25, // 25% of the screen width
                  height: MediaQuery.of(context).size.height *
                      0.05, // Dynamic height
                  decoration: ShapeDecoration(
                    color: const Color(0xFFCE0014),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Dynamic space

              // "Create Now" Section
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Do not have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Create Now',
                      style: TextStyle(
                        color: Color(0xFFCE0014),
                        fontSize: 11,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Dynamic space

              // Sign in with Google
              Container(
                width: MediaQuery.of(context).size.width *
                    0.5, // 50% of screen width
                height:
                    MediaQuery.of(context).size.height * 0.05, // Dynamic height
                decoration: ShapeDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height *
                          0.03, // Dynamic size for icon
                      height: MediaQuery.of(context).size.height * 0.03,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/google_logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // Dynamic space

              // Sign in with Apple
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height *
                          0.03, // Dynamic size for icon
                      height: MediaQuery.of(context).size.height * 0.03,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/apple_logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      'Sign in with Apple',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
