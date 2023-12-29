import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:testing_procces/point_screen.dart';
import 'point.dart';

class MapModel extends ChangeNotifier {
  final MapController _mapController = MapController();
  final List<Point> _points = [];
  Position? _currentPosition;
  String? _pointName;
  int _pointCounter = 0;

  List<LatLng> get _layerPoints => [
        LatLng(55.755793, 37.617134),
        LatLng(55.095960, 38.765519),
        LatLng(56.129038, 40.406502),
        LatLng(54.513645, 36.261268),
        LatLng(54.193122, 37.617177),
        LatLng(54.629540, 39.741809),
      ];

  MapController get mapController => _mapController;
  List<Point> get points => _points;
  String? get pointName => _pointName;

  void setPointName(String name) {
    _pointName = name;
    notifyListeners();
  }

  //запрашиваем пермишн на отслеживание местоположения
  Future<void> _getCurrentLocation() async {
    var locationPermissionStatus = await Permission.location.status;

    if (locationPermissionStatus == PermissionStatus.granted) {
      _fetchLocation();
    } else {
      var permissionResult = await Permission.location.request();
      if (permissionResult == PermissionStatus.granted) {
        _fetchLocation();
      } else {
        print('Разрешение не получено');
      }
    }
  }

  MapModel() {
    _getCurrentLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = newPosition;
      _mapController.move(
          LatLng(newPosition.latitude, newPosition.longitude), 15.0);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addPoint(LatLng point) {
    _pointCounter++;
    String pointName = 'Точка ${_pointCounter}';
    _points.add(Point(
        name: pointName, latitude: point.latitude, longitude: point.longitude));
    _pointName = null;
    notifyListeners();
  }

  void deletePoint(Point point) {
    _points.remove(point);
    notifyListeners();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final locationNotifier = Provider.of<MapModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: locationNotifier.mapController,
            options: MapOptions(
              center: LatLng(0, 0),
              zoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  for (var point in locationNotifier.points)
                    Marker(
                      height: 30.0,
                      width: 30.0,
                      point: LatLng(point.latitude, point.longitude),
                      builder: (context) => Container(
                        child: Image.asset(
                          'lib/assets/Location.png',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 15,
            left: MediaQuery.of(context).size.width / 2 - 15,
            child: Image.asset(
              'lib/assets/aim_for_map.png',
              width: 30.0,
              height: 30.0,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "hero1",
              backgroundColor: Colors.white,
              onPressed: () {
                locationNotifier.addPoint(LatLng(
                    locationNotifier.mapController.center.latitude,
                    locationNotifier.mapController.center.longitude));
              },
              child: const Icon(
                Icons.add,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            FloatingActionButton(
              heroTag: "hero2",
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PointScreen()),
                );
              },
              tooltip: 's',
              child: const Icon(Icons.menu, color: Colors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}
