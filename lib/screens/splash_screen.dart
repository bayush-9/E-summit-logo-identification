import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_identifier/screens/home_page.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  gotToHome() {
    Timer(
      const Duration(seconds: 3),
      () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => Homepage()));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    gotToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Image.asset('assets/ecell_logo_dark.jpeg'),
        ),
      ),
    );
  }
}
