import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/firebase_auth.dart';
import './dev_menu.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [
              AndroidLarge1(),
            ],
          ),
        ),
      ),
    );
  }
}

class AndroidLarge1 extends StatefulWidget {
  const AndroidLarge1({super.key});

  @override
  _AndroidLarge1State createState() => _AndroidLarge1State();
}

class _AndroidLarge1State extends State<AndroidLarge1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/AppLogoTransparent.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Welcome Text
              Center(
                child: Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCE0014),
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Email Section
              Text(
                'Email:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: ShapeDecoration(
                  color: const Color(0xFFDDDDDD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: _emailController,
                    cursorColor: Color(0xFFCE0014),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Password Section
              Text(
                'Password:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: ShapeDecoration(
                  color: const Color(0xFFDDDDDD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Color(0xFFCE0014),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              // Forgot Password aligned to the right
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFFCE0014),
                    fontSize: 12,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Login Button
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFCE0014),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // "Create Now" Section
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle navigation to sign up page
                  },
                  child: Text.rich(
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
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Sign in with Google
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : signInWithGoogle,
                  child: Container(
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
                          width: MediaQuery.of(context).size.height * 0.03,
                          height: MediaQuery.of(context).size.height * 0.03,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/google_logo.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
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
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Sign in with Apple
              Center(
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          // Handle Apple sign in
                        },
                  child: Container(
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
                          width: MediaQuery.of(context).size.height * 0.03,
                          height: MediaQuery.of(context).size.height * 0.03,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/apple_logo.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authServices.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Logged in successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFCE0014),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DevMenu()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.displayName);

      // Navigate to dev menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DevMenu()),
      );

      Fluttertoast.showToast(
        msg: "Logged in successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFCE0014),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
