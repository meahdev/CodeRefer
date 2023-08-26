import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  Location _location = Location();
  Set<Marker> _markers = {};
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  Map<PolylineId, Polyline> _polylines = {};
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getApiKey();
    _location.onLocationChanged.listen((LocationData locationData) {
      print('called lisntener ${locationData.latitude}');
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  Future<String?> getApiKey() async {
    final propertiesString = await rootBundle.loadString('secrets.properties');
    final properties = propertiesString.split('\n');
    final propertyMap = Map.fromEntries(
      properties.map((property) {
        final splitProperty = property.split('=');
        return MapEntry(splitProperty[0], splitProperty[1]);
      }),
    );
    final apiKey = propertyMap['API_KEY'];
    print('apiKey:: $apiKey');
    return apiKey;
  }

  void _updateMap() async {
    if (_currentLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          20, // Zoom level
        ),
      );
      _updateMarkers();
      // _updatePolylines();
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(_currentLocation!.latitude!,
              _currentLocation!.longitude!), // Default destination coordinates
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    });
  }

  void _updatePolylines() async {
    _polylineCoordinates.clear();
    _polylines.clear();

    PointLatLng? destinationLatLng =
        await _getLatLngFromAddress(_destinationController.text);
    if (destinationLatLng != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'destination');
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position:
              LatLng(destinationLatLng.latitude, destinationLatLng.longitude),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );

      print('desi:: ${destinationLatLng}');

      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBURqsXWTLU3ZzhYdftmtUsQPFm37sLLa4",
        PointLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        destinationLatLng,
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      setState(() {
        PolylineId id = const PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: _polylineCoordinates,
          width: 3,
        );
        _polylines[id] = polyline;
      });
    }
  }

  Future<PointLatLng?> _getLatLngFromAddress(String address) async {
    // You can use a geocoding service like Geocoding API to get the coordinates from the address
    // Implement the logic to fetch coordinates based on the address
    // Here, we are returning hardcoded coordinates for demonstration purposes
    return PointLatLng(9.9312, 76.2673); // Default destination coordinates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateMap();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentLocation?.latitude ?? 9.9312,
                    _currentLocation?.longitude ??
                        76.2673), // Initial map center
                zoom: 12.0, // Initial map zoom level
              ),
              markers: _markers,
              // polylines: Set<Polyline>.of(_polylines.values),
            ),
          ),
        ],
      ),
    );
  }
}
