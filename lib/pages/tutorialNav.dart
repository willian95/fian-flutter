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

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerScrimColor: Colors.transparent,
      drawer:NavigationDrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(""),
      ),
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                
                children: [

                    Container(
                      child: Column(
                        
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: 15),
                            child: Center(
                              child: Text("TUTORIAL", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white )) 
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
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
                                                        child: Center(child: Text("Aquí podrás encontrar las actividades diarias junto con la fase lunar", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey))),
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
                                                    child: Center(child: Text("Al hacer click en cualquier icono de actividad mostrará su información respectiva", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w400))),
                                                  )
                                                  
                                                ],
                                              )),
                                            )

                                            else if(data == "3") 
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: (Column(
                                                children: [
                                                  
                                                  Container(margin: EdgeInsets.only(top: 50), child: Image.asset("images/tuto2.png")),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 15),
                                                    child: Center(child: Text("Al hacer click en el icono del calendario desplegará un calendario para consultar cualquier fecha deseada", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w400))),
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
                                                    child: Center(child: Text("Al hacer click en una fecha del calendario te llevará a la fecha consultada", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w400))),
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
                                                    child: Center(child: Text("Aquí podrás consultar los mercados disponibles", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w400))),
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
      path_0.moveTo(0,0);
      path_0.lineTo(size.width,0);
      path_0.lineTo(size.width, size.height*0.100000);
      path_0.quadraticBezierTo(size.width*-0.001,size.height*0.10000,0,size.height*0.250000);
     
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

