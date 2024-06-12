import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../business/auth/registerController/RegisterController.dart';
import '../../../../business/homeController/HomeController.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final homeController = Get.put(HomeController());
  final registerController = Get.put(RegisterController());
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset('assets/video/Splash.mp4')
          ..initialize().then((value) {
            setState(() {
              videoPlayerController.play();
            });
          });
    time();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  time() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await getCurrentLocation();
    await Timer(
      const Duration(seconds: 5),
      () {
        if (prefs.getBool("islogin") == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/drower', ModalRoute.withName('/drower'));
        } else {
          Navigator.pushNamedAndRemoveUntil(context, "/into_slider_screen",
              ModalRoute.withName('/into_slider_screen'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  ///get current location
  getCurrentLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the scenario when the user denies permission
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the scenario when the user denies permission forever
      return;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    homeController.lat = position.latitude;
    homeController.lng = position.longitude;
    registerController.lat = position.latitude;
    registerController.lng = position.longitude;
    print("bvc " + registerController.lat.toString());

    // Convert the position into an address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the address name from the placemark
    Placemark placemark = placemarks.first;
    String address = placemark.street ?? '';

    // Update the UI with the current address
    setState(() {
      homeController.currentAddress = address;
    });
  }
}
