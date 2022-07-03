import 'service.dart';

Future<void> main() async {
  final List<List<dynamic>> points = [
    [Point(1, "Ayasofya Camii", 41.0085277, 28.9801481), 1],
    [Point(2, "Galata Kulesi", 41.0255385, 28.974281), 1],
    [Point(3, "Dolmabahçe Sarayı", 41.0391438, 29.0003369), 0],
    [Point(4, "Çırağan Sarayı", 41.0439597, 29.0161189), 0],
    [Point(5, "Büyük Mecidiye Camii", 41.0472031, 29.0269527), 0]
  ];

  List a = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]];
  List<List<dynamic>> dumps = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]];

  int i = 0;
  int j = 0;

  for(i; i<points.length; i++){
    for(j; j<points.length; j++){
      if(i == j){
        a[i][j] = 0;
        continue;
      }else if (a[j][i] != 0){
        dumps[i][j] = dumps[j][i];
        continue;
      }else {
        print("$i -> $j");
        a[i][j] = 1;
        dumps[i][j] = await GraphHopper.getRoute(points[i][0], points[j][0]);
        await Future.delayed(const Duration(milliseconds: 15));
      }
    }
    j = 0;
  }
  print(dumps);
}