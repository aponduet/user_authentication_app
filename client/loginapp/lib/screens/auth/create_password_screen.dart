import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/components/validation.dart';
import 'package:loginapp/models/data.dart';
import 'package:loginapp/screens/auth/login_screen.dart';
import '../../components/custom_input.dart';
import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  final String? email;
  const NewPassword({Key? key, this.email}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  Data? userInfo;
  bool isPassUpdated = false;
  bool isMakingPass = false;
  Future<int>? _statusCode;

  Future<int> send() async {
    const String apiUrl = "http://localhost:5000/updatepass";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": widget.email, "password": _pass.text}));

    if (response.statusCode == 200) {
      setState(() {
        isPassUpdated = true;
      });
      print("Password Updated Successfully");
      return response.statusCode;
    } else {
      print("Failed to update password");
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isPassUpdated
        ? const LoginScreen()
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "Create New Password",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                              ),
                            ),
                            InputField(
                              controller: _pass,
                              labelText: "Password",
                              obscureText: isShowPass,
                              prefixIcon: const Icon(Icons.password_outlined),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: isShowPass
                                      ? const Icon(
                                          Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isShowPass = !isShowPass;
                                    });
                                  },
                                ),
                              ),
                              validator: (String? val) {
                                if (!val!.isValidPassword) {
                                  return 'Password should be combination of uppercase, lowercase,\n digit, and special character';
                                } else if (val.isEmpty) {
                                  return "Please Enter Password";
                                } else if (val.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputField(
                              controller: _confirmPass,
                              labelText: "Confirm Password",
                              obscureText: isShowPass,
                              prefixIcon: const Icon(Icons.password_outlined),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: isShowPass
                                      ? const Icon(
                                          Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isShowPass = !isShowPass;
                                    });
                                  },
                                ),
                              ),
                              validator: (String? val) {
                                if (val != _pass.text) {
                                  return 'Password does not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        isMakingPass = true;
                                      });
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Save Password"),
                                  ),
                                ),
                              ],
                            ),
                            isMakingPass
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
                                              'Password Succesfully Updated',
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
                                                "Failed to Update Password",
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
                        ),
                      ))
                ],
              ),
            ),
          );
  }
}
