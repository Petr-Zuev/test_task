import 'package:flutter/material.dart';
import 'map.dart';

class Point {
  final String name;
  final double latitude;
  final double longitude;

  Point({required this.latitude, required this.longitude, required this.name});
}
//содержит точку, информацию о координатах.
// Используется в классе MapModel для создания точек 