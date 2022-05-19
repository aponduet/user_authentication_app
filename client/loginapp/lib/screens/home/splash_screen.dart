import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../auth/login_screen.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<int> checkUser() async {
    final box = Hive.box('infoBox');
    final boxData = box.getAt(0);
    if (boxData.jwt != null) {
      return 200;
    } else {
      return 500;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(),
      builder: ((context, snapshot) {
        //if (!snapshot.hasData) return const Splash();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash();
        } else {
          if (snapshot.data == 200) {
            return const Homepage();
          } else {
            return const LoginScreen();
          }
        }
      }),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Checking User...",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
