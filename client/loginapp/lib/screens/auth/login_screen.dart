// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loginapp/components/validation.dart';
import 'package:loginapp/screens/auth/reset_password_screen.dart';
import 'package:loginapp/screens/auth/signup_screen.dart';
import 'package:loginapp/screens/home/homepage.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_input.dart';
import '../../models/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  bool isLoginrun = false;
  bool isLogedIn = false;
  Future<int>? _statusCode;

  // @override
  // void initState() {
  //   final box = Hive.box('infoBox');
  //   final data = box.get('secret');
  //   if (data != null) {
  //      Navigator.push(
  //         context, MaterialPageRoute(builder: (_) => const Homepage()));
  //   }

  //   super.initState();
  // }
  //User Login Function
  Future<int> send() async {
    const String apiUrl = "http://localhost:5000/login";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": _email.text, "password": _pass.text}));

    Data userInfo = Data.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      // final box = Hive.box('userBox');
      // box.put('jwt', userInfo.jwt);

      final infoBox = Hive.box('infoBox');
      infoBox.add(userInfo);
      Data rana = infoBox.getAt(0);
      print(rana.email);

      setState(() {
        isLogedIn = true;
      });

      print(rana.email);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLogedIn
        ? Homepage(email: _email.text)
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
                          "Login Page",
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
                                  prefixIcon:
                                      const Icon(Icons.password_outlined),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                      icon: isShowPass
                                          ? const Icon(
                                              Icons.visibility_off_outlined)
                                          : const Icon(
                                              Icons.visibility_outlined),
                                      onPressed: () {
                                        setState(() {
                                          isShowPass = !isShowPass;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (String? val) {
                                    if (!val!.isValidPassword) {
                                      return 'Enter Valid Password';
                                    } else if (val.isEmpty) {
                                      return "Please Enter Password";
                                    } else if (val.length < 8) {
                                      return "Password must be atleast 8 characters long";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: (() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetPassword(),
                                          ));
                                    }),
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const SignupScreen()));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoginrun = true;
                                              _statusCode = send();
                                              // }
                                            });
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Login"),
                                        )),
                                  ],
                                ),
                                isLoginrun
                                    ? FutureBuilder(
                                        future: _statusCode,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            if (snapshot.data == 200) {
                                              return Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Login Successfull ${snapshot.data}',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ));
                                            } else if (snapshot.data == 201) {
                                              return const Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'User not found',
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ));
                                            } else {
                                              return Center(
                                                //child: Text('${snapshot.data}'));
                                                // child: Text("${snapshot.data} "),
                                                child: Text(
                                                    'Login Failed, The jwt is : "${snapshot.data}"'),
                                              );
                                            } // snapshot.data  :- get your object which is pass from your downloadData() function
                                          }
                                        })
                                    : const SizedBox(
                                        width: 10,
                                      )
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
