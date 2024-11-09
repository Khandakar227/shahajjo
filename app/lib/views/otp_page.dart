import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shahajjo/services/auth.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:shahajjo/services/firebase_notification.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({required this.phoneNumber, super.key});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    void verifyOtp() async {
      setState(() {
        _isLoading = true;
      });
      try {
        bool isVerified =
            await _authService.verifyOtp(widget.phoneNumber, _otp);
        setState(() {
          _isLoading = false;
        });
        print(widget.phoneNumber);
        if (!isVerified) {
          showToast('OTP যাচাই ব্যর্থ হয়েছে');
          return;
        }
        showToast('OTP যাচাই সফল হয়েছে');

        //save token

        // FirebaseNotification().requestPermission();
        // FirebaseNotification().getToken();

        Navigator.popAndPushNamed(context, '/home');
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showToast('OTP যাচাই ব্যর্থ হয়েছে');
      }
    }

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
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
                              image:
                                  AssetImage('assets/AppLogoTransparent.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      // Welcome Text
                      Center(
                        child: Text(
                          'আপনার নম্বরে পাঠানো OTP লিখুন',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFCE0014),
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      Pinput(
                        length: 6,
                        animationCurve: Curves.easeIn,
                        validator: (value) {
                          setState(() {
                            _isLoading = true;
                            _otp = value!;
                          });
                          verifyOtp();
                          return null;
                        },
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      // Proceed Button
                      Center(
                        child: GestureDetector(
                          onTap: _isLoading ? null : verifyOtp,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: ShapeDecoration(
                              color: _isLoading
                                  ? Colors.grey
                                  : const Color(0xFFCE0014),
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
                                : const Text(
                                    'যাচাই করুন',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),

                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'আপনি যদি OTP না পান',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' আবার পাঠান',
                                style: const TextStyle(
                                  color: Color(0xFFCE0014),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showToast('OTP পুনরায় পাঠানো হবে');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
