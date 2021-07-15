import 'package:flutter/material.dart';
import 'package:FIAN/pages/phoneConfiguration.dart';
import 'package:localstorage/localstorage.dart';
import 'package:google_fonts/google_fonts.dart';

final storage = new LocalStorage('events.json');

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.yellow.shade600, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: WelcomePage(),

));

class WelcomePage extends StatefulWidget{
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State <WelcomePage> {

  String phoneNumber;

  var loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {return false;},
          child: CustomPaint(
          painter: BluePainter(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                children: [
                  
                  Center(child: Container(
                    transform: Matrix4.translationValues((MediaQuery.of(context).size.width/2)*-1 + 40, MediaQuery.of(context).size.height - 170, 0.0),
                    child: Image.asset("images/hoja2.png", width: 160, height: 160),
                  )),

                  Center(child: Container(
                    transform: Matrix4.translationValues(MediaQuery.of(context).size.width/2 - 40, MediaQuery.of(context).size.height - 170, 0.0),
                    child: Image.asset("images/hoja3.png", width: 160, height: 160),
                  )),
                  
                  Column(
                  
                  children: [

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child:Center(
                        child: Text("Calendario", style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: HexColor("#144E41")
                        )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child:Center(
                        child: Text("Agropecuario", style: GoogleFonts.montserrat(
                          fontSize: 30,
                          color: HexColor("#144E41")
                        )),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:Center(
                        child: Text("¡Le damos la bienvenida compadre o comadre!", 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, 
                            color: HexColor("#144E41"), 
                            fontSize: 15
                          )
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 30, 40, 60),
                      child: Text("El calendario Agropecuario y alimentario es un trabajo colectivo de organizaciones que buscan mantenerte al día con el ciclo luna", textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: HexColor("#959595")),
                      ),
                    ),

                    Center(
                      child: ElevatedButton(
                        child: Text(
                          "continuar".toUpperCase(),
                          style: GoogleFonts.montserrat(fontSize: 14)
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(50, 20, 50, 20)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(HexColor("#144E41")),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: HexColor("#144E41"))
                            )
                          )
                        ),
                        onPressed: () async{

                          await storage.ready; 
                          storage.setItem("welcomeStored", "true");

                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => PhoneConfiguration()
                          ));
                        }
                      )

                    ),

                  ]

                 ),
                ]
              )
            )
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
      path_0.quadraticBezierTo(size.width*-0.02,size.height*0.95000,0,size.height*0.6500000);
     
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
