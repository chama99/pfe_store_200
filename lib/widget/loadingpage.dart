// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../onboardingPage/Onboarding.dart';
import '../pages/connexion.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var resultSeen = GetStorage().read("seen");
  @override
  void initState() {
    // one single time
    Timer(
      const Duration(seconds: 4),
      () => Get.to(() => resultSeen == 1 ? const Connexion() : Onboarding()),
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
          children: const [
            Center(
              child: SpinKitChasingDots(
                color: Colors.orange,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Déconnexion...",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
