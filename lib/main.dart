import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Locator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
        primary:const Color(0XFF0A2239),
        ),
      ),
      home: const MyHomePage(title: 'GPS Locator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _latitude = "";
  var _longitude = "";
  var _altitude = "";
  var _speed = "";
  var _adress = "";

  Future<void> _updatePosition() async{
    Position pos = await _determinePosition();
    List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _altitude = pos.altitude.toString();
      _speed = pos.speed.toString();
      _adress = pm[0].toString();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF53a2be),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:Column(
          children: <Widget>[
            const Text(
              "Your last known location is:",
            ),
            Text(
              "Latitude: " + _latitude,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "Longitude: " + _longitude,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "Altitude: " + _altitude,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "Speed: " + _speed,
              style: Theme.of(context).textTheme.headline5,
            ),
            const Text("Adress: "),
            Text(_adress),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePosition,
        tooltip: "Get GPS Location",
        child: const Icon(Icons.change_circle_outlined),
        )
    );
  }
}
