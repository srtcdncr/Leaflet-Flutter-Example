import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GraphHopper {
  static Future<List<Polyline>> getRoute(Point point1, Point point2) async {
    double lat1 = point1.lat;
    double lat2 = point2.lat;
    double lng1 = point1.lng;
    double lng2 = point2.lng;
    bool elevataion = false;
    String APIKey = "";

    final res = await http.get(Uri.parse("https://graphhopper.com/api/1/route?"
        "point=$lat1,$lng1&"
        "point=$lat2,$lng2&"
        "type=json&"
        "locale=tr-TR&"
        "key=$APIKey&"
        "points_encoded=false&"
        "elevation=$elevataion"
        "profile=car"));

    final resData = json.decode(res.body);
    List<dynamic> cords = resData["paths"][0]["points"]["coordinates"];

    List<LatLng> points = cords.map((e) => LatLng(e[1], e[0])).toList();

    return [
      Polyline(
        points: points,
        strokeWidth: 4.0,
        color: Colors.amber
      )
    ];
  }
}

class Point{
  int id;
  double lat;
  double lng;
  String name;

  Point(this.id, this.name, this.lat, this.lng);
}