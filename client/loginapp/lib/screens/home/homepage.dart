import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loginapp/models/data.dart';
import 'package:loginapp/screens/auth/login_screen.dart';
import 'package:loginapp/screens/home/splash_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
    String? email,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLogedin = false;
  Data? userData;
  Future<int>? _check;

  Future<int> _userChecker() async {
    final box = Hive.box('infoBox');
    final boxData = box.getAt(0);
    if (boxData.jwt != null) {
      setState(() {
        userData = boxData;
      });
      return 200;
    } else {
      return 500;
    }
  }

  @override
  void initState() {
    setState(() {
      _check = _userChecker();
    });
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _check,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data == 200) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("My Blog"),
                  actions: [
                    TextButton.icon(
                      onPressed: () {
                        // setState(() {
                        //   isLogedin = false;
                        // });
                        final box = Hive.box('infoBox');
                        box.deleteAt(0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SplashScreen()));
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Profile(
                  username: userData!.username,
                  email: userData!.email,
                  jwt: userData!.jwt,
                ),
              );
            } else {
              return const LoginScreen();
            }
          }
        });
  }
}

Widget Profile({String? username, String? email, String? jwt}) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          '../../../images/sohel.jpg',
          width: 300,
          height: 300,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          " $username",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text("$email"),
        Text("$jwt"),
      ],
    ),
  );
}
