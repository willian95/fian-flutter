import 'package:flutter/material.dart';
import 'package:FIAN/pages/tutorial.dart';
import 'package:FIAN/pages/confirmNumber.dart';
import 'package:FIAN/pages/firstPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:google_fonts/google_fonts.dart';

final storage = new LocalStorage('events.json');

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.yellow.shade600, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: PhoneConfiguration(),

));

class PhoneConfiguration extends StatefulWidget{
  @override
  _PhoneConfiguration createState() => _PhoneConfiguration();
}

class _PhoneConfiguration extends State <PhoneConfiguration> {

  String phoneNumber;
  String phoneNumberError = "";

  var loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {return false;},
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text("Sabemos que puedes encontrarte en un lugar donde la señal no sea la mejor.",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: HexColor("#959595")
                        ),),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                        child: Text("Si quieres recibir mensajes de texto vía SMS, para actualizarte acerca del ciclo lunar y las Actividades recomendadas para cada día.",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: HexColor("#959595")
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text("¡Déjanos tu número!",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: HexColor("#959595")
                        ),),
                      ),
                      Column(
                        children:[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 3),
                            child: Text("Ingresa tu número celular",  style: GoogleFonts.montserrat(
                              fontSize: 15
                            )),
                          ),
                          Form(
                            key: formKey,
                            child: Column(  
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(flex: 1, child: Text("+57", style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600))),
                                      Flexible(flex:5, child: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: buildPhoneField(),
                                      )),
                                    ],
                                  ),
                                ),
                                Text(phoneNumberError, textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.red)),
                                if(loading == true)( CircularProgressIndicator() )
                                else(
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      child: Text(
                                        "confirmar".toUpperCase(),
                                        style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color:  Colors.white)
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

                                        this.phoneNumberError = "";
                                        print(formKey.currentState.validate());
                                        if(!formKey.currentState.validate()){
                                          return;
                                        }else{
                                          print("here");
                                          formKey.currentState.save();
                                        
                                          try{
                                            setState((){
                                              loading = true;
                                            });
                                            var data = await http.post('https://app.fiancolombia.org/api/store-number', body: {
                                              'phoneNumber': phoneNumber
                                            });
                                            
                                            setState((){
                                              loading = false;
                                            });

                                            
                                            var response = json.decode(data.body);

                                            if(response["success"] == true){
                                              Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) => ConfirmNumber(phoneNumber)
                                              ));
                                            }else{

                                              AlertDialog alert = AlertDialog(
                                                title: Text(response["msg"])
                                              );

                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                },
                                              );

                                            }
                                          }on Exception catch(_){

                                            AlertDialog alert = AlertDialog(
                                              title: Text("No posees conexión a internet")
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );

                                            setState((){
                                              loading = false;
                                            });

                                          }

                                        }


                                      }
                                    ),
                                  )
                                ),

                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 40),
                                  child: TextButton(
                                    child: Text("Omitir", style: GoogleFonts.montserrat(color: HexColor("#7f8c8d"), fontWeight: FontWeight.bold)),
                                    onPressed: () async {

                                      await storage.ready;
                                      var tutorialStored = await storage.getItem("tutorialstored");

                                      if(tutorialStored == "true"){
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>FirstPage()), (Route<dynamic> route) => false);
                                      }else{
                                        
                                        Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => Tutorial()
                                        ));

                                      }

                                    },
                                  ),
                                ),
                                
                                
                              ],
                            ),
                          )
                        ]
                      )
                    ],
                  ),
                  
                  Container(
                    
                    child: CustomPaint(
                      painter:BluePainter(),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(-40, 0, 0.0),
                                    child: Image.asset("images/hoja1.png", width: 100, height: 100),
                                  ),
                                  Image.asset("images/hoja3.png", width: 70, height: 70)
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                            child: Text(
                                "Te recomendamos que ingreses tu número de celular (no es obligatorio), de lo contrario puedes continuar",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white
                              ),

                            )
                          ),
                        ],
                      ),
                    ),
                  ),

                ]

              ),
            ),
          ),
      )
    );
  }

  Widget buildPhoneField(){
    return Material(
      elevation: 10,
      borderRadius: new BorderRadius.circular(10.0),
      borderOnForeground: true,
      child: TextFormField(
        maxLength: 10,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white,
          isDense: false,
          filled: false,
          counterText: "",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding:EdgeInsets.only(bottom: 15, top: 15),
          hintText: "(012) - 345 6789",
          //fillColor: Colors.green
        ),
        validator: (String value){
          if(value.isEmpty){
            return 'Número de teléfono es requerido';
            
          }
          else if(value.length > 10){
            return 'Número de teléfono debe tener 10 dígitos';
            
          }

          else if(value.length < 10){
            return 'Número de teléfono debe tener 10 dígitos';
          }
        },
        onSaved: (String value){
          phoneNumber = value;
        },
      ),
    );
  }

}

  class BluePainter extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      
      Paint paint = Paint();
      paint.color = HexColor("#144E41");
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 8;

      Path path_0 = Path();
      path_0.moveTo(0,size.height);
      path_0.lineTo(size.width,size.height);
      path_0.lineTo(size.width,size.height*0.3600000);
      path_0.quadraticBezierTo(size.width*0.1500000,size.height*0.4800000,0,0);
      path_0.quadraticBezierTo(0,size.height*0.2500000,0,size.height);
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
