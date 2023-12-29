import 'package:flutter/material.dart';
import 'package:testing_procces/map.dart';
import 'package:provider/provider.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({Key? key}) : super(key: key);

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  @override
  Widget build(BuildContext context) {
    final locationNotifier = Provider.of<MapModel>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('Список точек',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var point in locationNotifier.points)
                Container(
                  height: 114,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 3),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${point.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 35,
                            width: 135,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 235, 230, 230),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: TextButton(
                              onPressed: () {
                                locationNotifier.deletePoint(point);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Удалить',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
