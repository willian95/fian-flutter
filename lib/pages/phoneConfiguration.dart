import 'package:flutter/material.dart';
import 'package:fian/pages/tutorial.dart';
import 'package:fian/pages/confirmNumber.dart';
import 'package:fian/pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

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

  var loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [

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
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Hola! Bienvenido al Calendario Agropecuario y Alimentario Oficial de Food First Information and Action Network (FIAN) para COLOMBIA!",
                        style: TextStyle(
                          fontSize: 18
                        ),
                        textAlign: TextAlign.center
                        ,
                      ),
                    )
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Sabemos que puedes encontrarte en un lugar donde la señal no sea la mejor! Así que si quieres recibir mensajes de texto via SMS para actualizarte acerca de los ciclos Lunares y las Actividades para cada día! Te recomendamos que ingreses tu número de celular (no es obligatorio), de lo contrario puedes continuar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),),
                    )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Icon(Icons.phone_android),
                ),
                Container(
                  child: Text("Ingresa tu # celular"),
                ),
                Form(
                  key: formKey,
                  child: Column(  
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                        child: buildPhoneField(),
                      ),

                      if(loading == true)( CircularProgressIndicator() )
                      else(
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                "Continuar", style: TextStyle(fontSize: 16)
                              ),
                            ),
                            onPressed: () async{

                              if(!formKey.currentState.validate()){
                                return;
                              }

                              formKey.currentState.save();
                              
                              try{
                                setState((){
                                  loading = true;
                                });
                                var data = await http.post('http://localhost:8000/api/store-number', body: {
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
                          
                          ),
                        )
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: TextButton(
                          child: Text("Saltar / Continuar", style: TextStyle(color: Colors.grey)),
                          onPressed: () async {

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

                            
                          },
                        ),
                      )
                    ],
                  ),
                )

              ]

            )
          )
        )
      )
    );
  }

  Widget buildPhoneField(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: new InputDecoration(
        labelText: "Número telefónico",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        isDense: true,
        filled: true,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(

          ),
        ),
        //fillColor: Colors.green
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Número de teléfono es requerido';
        }
      },
      onSaved: (String value){
        phoneNumber = value;
      },
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
