import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './OTP_Login_Page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [
              PhoneLoginView(),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({super.key});

  @override
  PhoneLoginViewState createState() => PhoneLoginViewState();
}

class PhoneLoginViewState extends State<PhoneLoginView> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
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
                  'Continue with your Phone Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCE0014),
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Phone Number Section
              Text(
                'Phone Number:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
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
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]'))
                    ],
                    cursorColor: const Color(0xFFCE0014),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Login Button
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (_phoneController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please enter a phone number.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xFFCE0014),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: _phoneController.text,
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        verificationFailed: (error) {
                          setState(() {
                            _isLoading = false;
                          });
                          Fluttertoast.showToast(
                            msg: error.message.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xFFCE0014),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        codeSent: (verificationId, resendingToken) async {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpLoginPage(
                                verificationId: verificationId,
                              ),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (verificationId) {
                          setState(() {
                            _isLoading = false;
                          });
                          Fluttertoast.showToast(
                            msg: 'OTP request timed out. Please try again.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xFFCE0014),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      );
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      Fluttertoast.showToast(
                        msg: 'Failed to send OTP. Try again.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xFFCE0014),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
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
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
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
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'অ্যাকাউন্ট নেই? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' এখনই তৈরি করুন',
                          style: TextStyle(
                            color: Color(0xFFCE0014),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        ),
      ],
    );
  }
}
