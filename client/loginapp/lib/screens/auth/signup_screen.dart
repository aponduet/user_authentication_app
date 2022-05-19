import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginapp/components/custom_input.dart';
import 'package:loginapp/components/validation.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/models/data.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  bool isCreated = false;
  Future<int>? _statusCode;
  Data? userdata;

  Future<int> send() async {
    const String apiUrl = "http://localhost:5000/create";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "username": _username.text,
          "email": _email.text,
          "password": _pass.text
        }));

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Signup User",
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
                          InputField(
                            controller: _username,
                            labelText: "Name",
                            validator: (val) {
                              if (!val!.isValidName) {
                                return 'Enter valid Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputField(
                            controller: _email,
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
                          InputField(
                            controller: _pass,
                            labelText: "Password",
                            obscureText: isShowPass,
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: isShowPass
                                    ? const Icon(Icons.visibility_off_outlined)
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
                                    ? const Icon(Icons.visibility_off_outlined)
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
                                      isCreated = true;
                                    });
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //       content: Text('Processing Data')),
                                    // );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Create account"),
                                ),
                              ),
                            ],
                          ),
                          isCreated
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
                                            'User Successfully Created',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ));
                                      } else if (snapshot.data == 202) {
                                        return const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Fields Must not be empty',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ));
                                      } else if (snapshot.data == 201) {
                                        return const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Email Already in use',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ));
                                      } else {
                                        return Center(
                                          //child: Text('${snapshot.data}'));
                                          child: Text("${snapshot.data} "),
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
