import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../model/location_response.dart';
import '../model/prediction_response.dart';

class MobileGroomingController extends GetxController {
  LatLng currentLatLng = LatLng(0.0, 0.0);
  GoogleMapController controller;

  TextEditingController searchTextcontroller = TextEditingController();
  String sessionToken = 'SESSION_TOKEN';
  String googlePlacesKey = "AIzaSyBkEMGux54F5lqQ7_bXIjWVf5m3jaRdYdk";
  List<Predictions> placeList = [];

  onPlaceSelected(
      Predictions pre, ValueChanged<LatLng> onLocationSelected) async {
    var response = await getLocationDetails(placeId: pre.placeId);
    searchTextcontroller.text = pre.description;
    if (pre != null) {
      double lat = response.result.geometry.location.lat ?? 0.0;
      double long = response.result.geometry.location.lng ?? 0.0;
      onLocationSelected.call(LatLng(lat, long));
    }
  }

  Future<List<Predictions>> getSuggestion(String input) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$googlePlacesKey&sessiontoken=$sessionToken';
      print('request is $request');
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        PredictionResponse res =
            PredictionResponse.fromJson(json.decode(response.body));
        placeList = res.predictions ?? [];
        print('place list is $placeList');
        return placeList;
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
      return [];
    }
  }

  Future<LocationResponse> getLocationDetails({String placeId}) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?placeid=$placeId&key=$googlePlacesKey';
      print('request is $request');
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var res = LocationResponse.fromJson(json.decode(response.body));
        return res;
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
      return LocationResponse();
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
