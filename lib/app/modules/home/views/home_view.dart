import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A button to request the location permission
            ElevatedButton(
              child: Text('Request location permission'),
              onPressed: () {
                // Call the requestPermission method from the controller
                controller.requestPermission();
                getLocationName();
              },
            ),
            SizedBox(height: 20),
            // A text widget to show the location permission status
            Obx(() => Text('Permission status: ${controller.permissionStatus.value}')),
            SizedBox(height: 20),
            // A text widget to show the current location and place name
            Obx(() {
              // Check if the permission is granted
              if (controller.permissionStatus.value == LocationPermission.whileInUse || controller.permissionStatus.value ==
                  LocationPermission.always ) {
                return FutureBuilder(
                  future: getLocationName(),
                  builder: (context, snapshot) {
                    // Check if the future is completed
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Check if there is any error
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Check if there is any data
                      if (snapshot.hasData) {
                        return Text('Location name: ${snapshot.data}');
                      }
                      return Text('No data');
                    }
                    // Show a progress indicator while the future is loading
                    return CircularProgressIndicator();
                  },
                );
              }
              return Text('No location');
            }),
          ],
        ),
      ),
    );
  }

  // A method to get the location name from the current position
  Future<String> getLocationName() async {
    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    // Get the place details from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // Return the first placemark's name

    for(int i=0; i<placemarks.length; i++){
      log("$i ->>>>>${placemarks[i].toString()}");
    }

    if(placemarks.length == 0){
      return 'Unknown';
    }else{
      return "\n${placemarks.first}";
    }

    return placemarks.first.name ?? 'Unknown';
  }
}