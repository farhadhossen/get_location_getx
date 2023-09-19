import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  // A variable to store the location permission status
  var permissionStatus = LocationPermission.denied.obs;

  // A method to request the location permission
  void requestPermission() async {
    // Check if the location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not, show a snackbar with a button to open the location settings
      Get.snackbar(
        'Location service is disabled',
        'Please enable it in the settings',
        mainButton: TextButton(
          child: Text('Open settings'),
          onPressed: () {
            // Open the location settings
            Geolocator.openLocationSettings();
          },
        ),
      );
      return;
    }

    // Request the location permission
    LocationPermission status = await Geolocator.requestPermission();
    // Update the permission status variable
    permissionStatus.value = status;

    // If the permission is denied, show a snackbar with a button to request again
    if (status == LocationPermission.denied) {
      Get.snackbar(
        'Location permission is denied',
        'Please allow it from the app settings',
        mainButton: TextButton(
          child: Text('Request again'),
          onPressed: () {
            // Request the permission again
            requestPermission();
          },
        ),
      );
      return;
    }

    // If the permission is denied forever, show a dialog with a button to open the app settings
    if (status == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: Text('Location permission is denied forever'),
          content: Text('Please allow it from the app settings'),
          actions: [
            TextButton(
              child: Text('Open settings'),
              onPressed: () {
                // Open the app settings
                Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      );
      return;
    }
  }

}
