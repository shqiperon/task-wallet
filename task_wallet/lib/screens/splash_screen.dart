import 'package:flutter/material.dart';
import 'package:task_wallet/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Adjust the duration as needed
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MainScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color you want
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your animations or images here
            Image.asset(
              'assets/images/task_wallet.png',
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
