import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/components/validation.dart';
import 'package:loginapp/screens/auth/create_password_screen.dart';
import '../../components/custom_input.dart';
import 'package:http/http.dart' as http;

import '../../models/otp_model.dart';

class OtpScreen extends StatefulWidget {
  final String? email;

  const OtpScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  Otp? userInfo;
  bool isCheckingOtp = false;
  bool isValidOtp = false;
  Future<int>? _statusCode;

  Future<int> send() async {
    const String apiUrl = "http://localhost:5000/otpverification";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": widget.email, "otp": _otpController.text}));

    if (response.statusCode == 206) {
      // final box = Hive.box('userBox');
      // box.put('jwt', response.body);
      var resObject = Otp.fromJson(jsonDecode(response.body));
      setState(() {
        userInfo = Otp(
          email: resObject.email,
        );
        isValidOtp = true;
      });
      print(userInfo!.email);
      return response.statusCode;
    } else {
      print("OTP does not matche");
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isValidOtp
        ? NewPassword(email: widget.email)
        : Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    child: Column(
                      children: [
                        const Text(
                          "Verification Code",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Text(
                                  "Check your e-mail and Enter verification code below.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InputField(
                                  controller: _otpController,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  labelText: "Enter OTP",
                                  validator: (val) {
                                    if (!val!.isValidOTP) {
                                      return 'Enter valid OTP';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Login Page",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _statusCode = send();
                                            isCheckingOtp = true;
                                          });

                                          if (isValidOtp) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const NewPassword()));
                                          }
                                        }
                                        return;
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("Submit"),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                isCheckingOtp
                                    ? FutureBuilder(
                                        //future এ প্যারামিটার হিসেবে ফাংশন পাস করলে এটি বল্ড মেথড এর সাথে বার বার কল হবে।
                                        //তাই, বার বার কল করা বন্ধ করতে এটিকে সেটস্টেইট বা ইনিট ফাংশনের ভেতর ডিফাইন করতে হবে।
                                        future: _statusCode,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            if (snapshot.data == 200) {
                                              return const Center(
                                                  child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  'OTP Successfully matched',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ));
                                            } else {
                                              return const Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Center(
                                                  //child: Text('${snapshot.data}'));
                                                  child: Text(
                                                    "OTP Does not Match!! ",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } // snapshot.data  :- get your object which is pass from your downloadData() function
                                          }
                                        },
                                      )
                                    : const SizedBox(
                                        width: 10,
                                      ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
