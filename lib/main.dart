import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:leaflet_example/mockService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaflet Example App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Polyline>> polylines = MockGraph.getRoute(points[4][0], points[1][0]);
  final _formKey = GlobalKey<FormState>();

  final List<List<dynamic>> points = [
    [Point(0, "Ayasofya Camii", 41.0085277, 28.9801481), true],
    [Point(1, "Galata Kulesi", 41.0255385, 28.974281), true],
    [Point(2, "Dolmabahçe Sarayı", 41.0391438, 29.0003369), true],
    [Point(3, "Çırağan Sarayı", 41.0439597, 29.0161189), true],
    [Point(4, "Büyük Mecidiye Camii", 41.0472031, 29.0269527), true]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black54,
          size: 30,
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for(var elem in points) Row(children: [
                  Checkbox(value: elem[1], onChanged: (value){
                    setState((){
                      elem[1] = value;
                    });
                  },),
                  Text(elem[0].name)
                ],),
                ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate() && points.where((element) => element[1] == true).toList().length != 2) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("2 farklı lokasyon seçmelisiniz.")));
                    }else{
                      var pts = points.where((element) => element[1] == true).toList();
                      setState(() {
                        polylines = MockGraph.getRoute(pts[0][0], pts[1][0]);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Kaydet"),
                )
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Polyline>>(
          future: polylines,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FlutterMap(
                options: MapOptions(
                  center: LatLng(41.027149,28.988778),
                  zoom: 12.5,
                  onTap: (tapPosition, point) {
                    setState(() {
                      debugPrint('onTap');
                    });
                  },
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                  ),
                  MarkerLayerOptions(
                    markers: [
                      for(var elem in points) if(elem[1] == true) Marker(
                        point: LatLng(elem[0].lat, elem[0].lng),
                        builder: (context) => Icon(color: Colors.red, size: 30, Icons.location_on_rounded),
                      )
                    ]
                  ),
                  PolylineLayerOptions(
                    polylines: snapshot.data!,
                    polylineCulling: true,
                  )
                ],
              );
            }
            return const Center(child: Text('Harita verileri yükleniyor'));
          }
        ),
    );
  }
}