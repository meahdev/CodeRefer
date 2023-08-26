import 'package:canary/model/prediction_response.dart';
import 'package:canary/providers/mobile_grooming_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  double customerLatitude;
  double customerLongitude;

  MapScreen({this.customerLatitude, this.customerLongitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  MobileGroomingController mobileGroomingController = Get.find();
  void getLocation() async {
    var loc = await currentLocation.getLocation();
    mobileGroomingController.controller
        ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
      zoom: 12.0,
    )));
    mobileGroomingController.currentLatLng =
        LatLng(loc.latitude, loc.longitude);
    _markers = {};
    setState(() {
      _markers = {
        Marker(
            markerId: MarkerId('Home'),
            position: LatLng(widget.customerLatitude ?? 0.0,
                widget.customerLongitude ?? 0.0))
      };
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(
        'lat and long ${widget.customerLatitude} - ${widget.customerLongitude}');
    _markers = {};
    setForEditLocation();
  }

  setForEditLocation() {
    _markers = {};
    setState(() {
      _markers = {
        Marker(
            markerId: MarkerId('Home'),
            position: LatLng(widget.customerLatitude ?? 0.0,
                widget.customerLongitude ?? 0.0))
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .3,
          child: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.customerLatitude, widget.customerLongitude),
              zoom: 18.0,
            ),
            onTap: (val) {
              _addMarker(val);
            },
            onMapCreated: (GoogleMapController controller) {
              mobileGroomingController.controller = controller;
            },
            markers: _markers,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              getLocation();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .05,
              width: MediaQuery.of(context).size.width * .1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Icon(
                Icons.location_searching,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TypeAheadField<Predictions>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: mobileGroomingController.searchTextcontroller,
                decoration: InputDecoration(
                    hintText: "Search Location",
                    contentPadding: EdgeInsets.all(15)),
              ),
              itemBuilder: (context, itemData) {
                if (itemData.description == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(itemData.description ?? ''),
                );
              },
              onSuggestionSelected: (suggestion) {
                mobileGroomingController.onPlaceSelected(suggestion, (val) {
                  _addMarker(val);
                });
              },
              suggestionsCallback: (pattern) async {
                var data;
                if (pattern.trim().isNotEmpty) {
                  if (mobileGroomingController.sessionToken == null) {
                    mobileGroomingController.sessionToken = Uuid().generateV4();
                  }
                  data = await mobileGroomingController.getSuggestion(pattern);
                }
                print('data is $data');
                return data;
              },
            ),
          ),
        )
      ],
    );
  }

  void _addMarker(LatLng pos) {
    mobileGroomingController.controller
        .animateCamera(CameraUpdate.newLatLng(pos));
    print("latitude ===== ${pos.latitude}");
    print("longitude ===== ${pos.longitude}");
    mobileGroomingController.currentLatLng =
        LatLng(pos.latitude, pos.longitude);
    _markers = {};
    setState(() {
      _markers = {
        Marker(
            markerId: MarkerId('origin'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: pos)
      };
    });
  }
}
