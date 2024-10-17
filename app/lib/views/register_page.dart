import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shahajjo/components/TextInput.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String phoneNumber = "";
  String name = "";

  bool _isLoading = false;

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
                  'নতুন একাউন্ট তৈরি করুন',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCE0014),
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // User Name
              TextInput(
                label: 'নাম:',
                onChanged: (value) => name = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              // Phone number
              TextInput(
                  label: 'মোবাইল নাম্বার',
                  onChanged: (value) => phoneNumber = value),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Register Button
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleRegister,
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
                            'নিবন্ধন করুন',
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
              const Center(
                child: LoginNow(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        ),
      ],
    );
  }

  void _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    try {
      showToast("লগ ইন সফল হয়েছে $name, $phoneNumber", Toast.LENGTH_SHORT);
    } catch (e) {
      showToast("লগ ইন সম্ভব হয়নি: ${e.toString()}", Toast.LENGTH_SHORT);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class LoginNow extends StatelessWidget {
  const LoginNow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'অ্যাকাউন্ট আছে? ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
              text: 'লগ ইন করুন',
              style: const TextStyle(
                color: Color(0xFFCE0014),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {}),
        ],
      ),
    );
  }
}
