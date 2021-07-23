import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:FIAN/pages/tutorial.dart';
import 'package:FIAN/pages/firstPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

final storage = new LocalStorage('events.json');

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.yellow.shade600, accentColor: Colors.yellowAccent),
  debugShowCheckedModeBanner: false,
  home: ConfirmNumber(""),

));

class ConfirmNumber extends StatefulWidget{

  final String phoneNumber;

  const ConfirmNumber(this.phoneNumber);

  @override
  _ConfirmNumber createState() => _ConfirmNumber();
}

class _ConfirmNumber extends State <ConfirmNumber> {

  String phoneNumber;
  String code;
  var loading = false;
  var checked = false;
  var message = "";

  TextEditingController textEditingController = TextEditingController();


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
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => {
                                Navigator.pop(context)
                              },
                            ),
                          ],
                        ),
                      ),
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
                      Text("¡Ya casi!", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: HexColor("#A2C617"), fontSize: 20)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                        child: Text("Por favor ingresa el código que acabaste de recibir por mensaje de texto (SMS)", textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: HexColor("#959595"))),
                      ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            PinCodeTextField(
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.white,
                                  blurRadius: 20,
                                )
                              ],
                              appContext: context,
                              length: 5,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              controller: textEditingController,
                              textStyle: TextStyle(
                                color: Colors.white
                              ),
                              cursorColor: Colors.white,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(15),
                                fieldHeight: 60,
                                activeColor: Colors.white,
                                inactiveFillColor: HexColor("#144E41"),
                                inactiveColor: Colors.white,
                                fieldWidth: 60,
                                activeFillColor: HexColor("#144E41"),
                                selectedFillColor: HexColor("#144E41"),
                              
                              ),
                 
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              onCompleted: (v) async {
                                
                                try{

                                    setState((){
                                      loading = true;
                                    });

                                    var data = await http.post('https://app.fiancolombia.org/api/verify-number', body: {
                                      'phoneNumber': widget.phoneNumber,
                                      'code': code
                                    });
                                    
                                    setState((){
                                      loading = false;
                                    });

                                    var response = json.decode(data.body);

                                    setState(() {
                                      message = response["msg"];
                                    });

                                    if(response["success"] == true){

                                      setState(() => {
                                        checked = true
                                      });

                                      await storage.ready; 
                                      storage.setItem("numberstored", "true");

                                      Timer(Duration(seconds: 3), () async {
                                        await storage.ready;
                                        var tutorialStored = await storage.getItem("tutorialstored");

                                        if(tutorialStored == "true"){
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>FirstPage()), (Route<dynamic> route) => false);
                                        }else{
                                          
                                          Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) => Tutorial()
                                          ));

                                        }

                                      });

                                      
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

                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  code = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                            
                            if(loading == true)
                            (
                              Container(
                                child: CircularProgressIndicator(),
                              )
                            ),

                            if(checked == true)
                            (
                              Container(
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 100
                                ),
                              )
                            ),

                            if(checked == false && loading == false && message != "")
                            (
                              Container(
                                child: Icon(
                                  Icons.clear,
                                  size: 100
                                ),
                              )
                              
                            ),
                            if(checked == false && loading == false && message != "")
                            (
                              Container(
                                child: Text(message)
                              )
                            ),
                            
                            Center(
                              child: TextButton(
                                child: Text("Reenviar mensaje", style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.bold)),
                                onPressed: () async {

                                  try{

                                    setState((){
                                      loading = true;
                                    });
                                    var data = await http.post('https://app.fiancolombia.org/api/store-number', body: {
                                      'phoneNumber': widget.phoneNumber
                                    });
                                    

                                    setState((){
                                      loading = false;
                                    });

                                    
                                    var response = json.decode(data.body);

                                    if(response["success"] == true){

                                      AlertDialog alert = AlertDialog(
                                        title: Text(response["msg"])
                                      );

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );

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
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  )

                    ]
                  ),
                 
                 

                ],
              
            ),
          ),
        )
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