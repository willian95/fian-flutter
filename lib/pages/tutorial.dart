import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:FIAN/pages/firstPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:google_fonts/google_fonts.dart';

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
  var tutorials = ["1", "2", "3", "4", "5"];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                
                children: [

                  Center(child: Container(
                    transform: Matrix4.translationValues((MediaQuery.of(context).size.width/2)*-1 + 60, MediaQuery.of(context).size.height - 280, 0.0),
                    child: Image.asset("images/hoja2.png", width: 300, height: 300),
                  )),

                  Center(child: Container(
                    transform: Matrix4.translationValues(MediaQuery.of(context).size.width/2 - 40, MediaQuery.of(context).size.height - 170, 0.0),
                    child: Image.asset("images/hoja3.png", width: 160, height: 160),
                  )),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: CarouselSlider(
                              carouselController: tutorialController,
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 500,
                                  initialPage: 0,
                                  enableInfiniteScroll: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: false,
                                  scrollDirection: Axis.horizontal,
                                ),
                                items: tutorials.map((data) {
                                  
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          
                                          children: [

                                            if(data == "1") 
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: (
                                                  Column(
                                                    children: [
                                                      Image.asset("images/tuto1.png", height: MediaQuery.of(context).size.height*0.45),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 15),
                                                        child: Center(child: Text("Acá te mostraremos todas las actividades agropecuarias de ESTE DÍA en particular", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontSize: 18))),
                                                      )
                                                    ],
                                                  )
                                                ),
                                              )
                                            
                                            else if(data == "2") 
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: (Column(
                                                children: [
                                                  
                                                  Image.asset("images/tuto4.png"),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15),
                                                    child: Center(child: Text("Al hacer click en cualquier icono de actividad mostrará su información respectiva", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontSize: 18))),
                                                  )
                                                  
                                                ],
                                              )),
                                            )

                                            else if(data == "3") 
                                            Container(
                                              height: 480,
                                 
                                              padding: const EdgeInsets.all(5.0),
                                              child: (Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(""),
                                                  Container(margin: EdgeInsets.only(top: 50), child: Image.asset("images/tuto2.png")),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15),
                                                    child: Center(child: Text("Al hacer click en el icono del calendario desplegará un calendario para consultar cualquier fecha deseada", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontSize: 18))),
                                                  )
                                                  
                                                ],
                                              )),
                                            )

                                            else if(data == "4") 
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: (Column(
                                                children: [
                                                  
                                                  Image.asset("images/tuto3.png", height: MediaQuery.of(context).size.height*0.45),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15),
                                                    child: Center(child: Text("Al hacer click en una fecha del calendario te llevará a la fecha consultada", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontSize: 18))),
                                                  )
                                                  
                                                ],
                                              )),
                                            )

                                            else if(data == "5") 
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: (Column(
                                                children: [
                                                  
                                                  Image.asset("images/tuto5.png", height: MediaQuery.of(context).size.height*0.45),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15),
                                                    child: Center(child: Text("Aquí podrás consultar los mercados disponibles", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontSize: 18))),
                                                  )
                                                  
                                                ],
                                              )),
                                            )

                                          ],

                                        ),
                                      ),
                                    ),
                                  );
                                  
                                }).toList(),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  child: Text(
                                    "continuar".toUpperCase(),
                                    style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(50, 20, 50, 20)),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(HexColor("#144E41")),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        side: BorderSide(color: HexColor("#144E41"))
                                      )
                                    )
                                  ),
                                  onPressed: () => {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>FirstPage()), (Route<dynamic> route) => false)
                                  }
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: TextButton(
                                  child: Text("Omitir todo", style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontWeight: FontWeight.bold)),
                                  onPressed: () async{

                                    await storage.ready; 
                                    storage.setItem("tutorialstored", "true");

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>FirstPage()), (Route<dynamic> route) => false);
                                  },
                                ),
                              )
                              
                            ],
                          )
                        ],
                      ),
                    )

                  ],
                ),
              )
          ),
        )
      );

  }

}

class BluePainter extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      Paint paint = Paint();
      paint.color = HexColor("#144E41");
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 20;

      Path path_0 = Path();
      path_0.moveTo(0,size.height);
      path_0.lineTo(size.width,size.height);
      path_0.lineTo(size.width, size.height*0.900000);
      path_0.quadraticBezierTo(size.width*-0.02,size.height*0.95000,0,size.height*0.7500000);
     
      canvas.drawPath(path_0, paint);

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

