import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:FIAN/widget/navigationDrawerWidget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.yellow.shade600, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: TutorialNav(),

));

class TutorialNav extends StatefulWidget{
  @override
  _TutorialNav createState() => _TutorialNav();
}

class _TutorialNav extends State <TutorialNav> {

  final CarouselController tutorialController = CarouselController();
  var tutorials = ["1", "2", "3", "4", "5"];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerScrimColor: Colors.transparent,
      drawer:NavigationDrawerWidget(),
      key:scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(""),
        leading: IconButton(
          icon: Image.asset('images/menu.png', width: 20, height: 20), 
          onPressed: () => scaffoldKey.currentState.openDrawer()
        ),
      ),
      body: Column(
        
        children: [
          CustomPaint(
            painter: BluePainter(),
            child: Container(
              height: 150,
              child: Center(
                child: Text("TUTORIAL", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold )) 
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CarouselSlider(
              carouselController: tutorialController,
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  height: MediaQuery.of(context).size.height * 0.60,
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
          
        ],
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
      path_0.quadraticBezierTo(size.width*0.0327750,size.height*0.7393000,size.width*0.1815000,size.height*0.7518000);
      path_0.quadraticBezierTo(size.width*0.3861250,size.height*0.7509125,size.width,size.height*0.7482500);
      path_0.lineTo(size.width,0);
      path_0.lineTo(0,0);
      path_0.lineTo(0,size.height);
      path_0.close();
     
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

