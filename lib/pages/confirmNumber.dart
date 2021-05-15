import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fian/pages/tutorial.dart';
import 'package:fian/pages/home.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
        child: Column(

            children: [
              Container(
                margin: EdgeInsets.all(5),
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
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: Image.asset("images/agriculture.png", width: 50, height: 50,),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: Text("Ya casi! Por favor ingresa el código que acabaste de recibir por mensaje de texto (SMS):", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
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
                          appContext: context,
                          length: 5,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          controller: textEditingController,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            activeColor: Colors.lightBlue,
                            inactiveFillColor: Colors.lightBlue,
                            inactiveColor: Colors.lightBlue,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          enableActiveFill: true,
                          onCompleted: (v) async {
                            
                            try{

                                setState((){
                                  loading = true;
                                });

                                var data = await http.post('http://localhost:8000/api/verify-number', body: {
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
                                      Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) => Home()
                                      ));
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
                            child: Text("Reenviar mensaje"),
                            onPressed: () => {

                            }
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              )


            ],
          
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