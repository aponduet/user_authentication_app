import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loginapp/components/validation.dart';
import 'package:loginapp/screens/auth/otp_screen.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_input.dart';
import '../../models/otp_model.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValidEmail = false;
  Otp? userInfo;
  bool isCheckRunning = false;
  Future<int>? _statusCode;
  Future<int> send() async {
    const String apiUrl = "http://localhost:5000/account";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": _email.text}));

    if (response.statusCode == 200) {
      print(response.statusCode);
      var resObject = Otp.fromJson(jsonDecode(response.body));

      // Local Veriable name and State Variable name must not be same, otherwise error will be occured.
      setState(() {
        userInfo = Otp(
          email: resObject.email,
        );
        isValidEmail = true;
      });
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isValidEmail
        ? OtpScreen(
            email: userInfo!.email,
          )
        : Scaffold(
            body: SizedBox(
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
                          "Account Recovery",
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
                                  "We will send a a verification code to your email address to reset your password",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InputField(
                                  controller: _email,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  labelText: "E-mail address",
                                  validator: (val) {
                                    if (!val!.isValidEmail) {
                                      return 'Enter valid email';
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
                                          //send();
                                          setState(() {
                                            _statusCode = send();
                                            isCheckRunning = true;
                                          });
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => const OtpScreen()));
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("Send Code"),
                                      ),
                                    ),
                                  ],
                                ),
                                isCheckRunning
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
                                                  'User Exist',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ));
                                            } else {
                                              return const Center(
                                                //child: Text('${snapshot.data}'));
                                                child: Text("User Not Fount"),
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
