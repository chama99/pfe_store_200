import 'dart:async';

import 'package:chama_projet/onboardingPage/Onboarding.dart';
import 'package:chama_projet/pages/connexion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<SplashScreen> {
  var resultSeen = GetStorage().read("seen");
  @override
  void initState() {
    // one single time
    Timer(
      Duration(seconds: 4),
      () => Get.to(() => resultSeen == 1 ? Connexion() : Onboarding()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("asset/logo.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
              child: Container(
                child: Lottie.asset('asset/loading.json',
                    height: size.height * 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
