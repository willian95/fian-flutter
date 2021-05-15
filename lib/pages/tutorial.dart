import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fian/pages/home.dart';
import 'package:localstorage/localstorage.dart';

final storage = new LocalStorage('events.json');

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.yellow.shade600, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: Tutorial(),

));

class Tutorial extends StatefulWidget{
  @override
  _Tutorial createState() => _Tutorial();
}

class _Tutorial extends State <Tutorial> {

  final CarouselController tutorialController = CarouselController();
  var tutorials = ["1", "2"];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: CarouselSlider(
                      carouselController: tutorialController,
                        options: CarouselOptions(
                          aspectRatio: 1,
                          viewportFraction: 0.8,
                          height: MediaQuery.of(context).size.height * 0.6,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: tutorials.map((data) {
                          
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 2,
                              child: Column(
                                
                                children: [

                                  if(data == "1") 
                                    (
                                      Column(
                                        children: [
                                          Image.asset("images/actividades.png", width: 100, height: 300,),
                                          Text("Aquí podrás encontrar la actividades del día")
                                        ],
                                      )
                                    )

                                  else if(data == "2") 
                                  (Column(
                                    children: [
                                      
                                      Image.asset("images/faselunar.png", width: 100, height: 300,),
                                      Text("Aquí se muestra la fase lunar")
                                      
                                    ],
                                  ))

                                ],

                              ),
                            ),
                          );
                          
                        }).toList(),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                        child: TextButton(
                          child: Text("No ver más", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                          onPressed: () async{

                            await storage.ready; 
                            storage.setItem("tutorialstored", "true");

                            Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => Home()
                            ));
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
                        child: ElevatedButton(onPressed: () => {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => Home()
                          ))
                        }, child: Text("continuar")),
                      )
                    ],
                  )

                ],
              ),
            )
        )
      )
    );

  }

}

class BluePainter extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      Paint paint = Paint();
      paint.color = HexColor("fdcb6e");;
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 20;

      Path customDesign = Path();
      customDesign.moveTo(size.width, size.height * 0.5);
      customDesign.lineTo(size.width, size.height);
      customDesign.lineTo(0, size.height);
      customDesign.lineTo(0, size.height * 0.3);
      canvas.drawPath(customDesign, paint);

    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate){
      return oldDelegate != this;
    }
  }

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

