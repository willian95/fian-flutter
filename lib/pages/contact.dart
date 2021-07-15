import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:FIAN/widget/navigationDrawerWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class Contact extends StatefulWidget{
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State <Contact> {

  var loading = false;
  String textDescription = "";
  String textEmail = "";
  String textName = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final descriptionHolder = TextEditingController();
  final emailHolder = TextEditingController();
  final nameHolder = TextEditingController();

  clearTextInput(){

    descriptionHolder.clear();
    emailHolder.clear();
    nameHolder.clear();

  }
 
  sendData() async {

   try{
      setState((){
        loading = true;
      });
      var data = await http.post('https://app.fiancolombia.org/api/contact', body: {
        'text': textDescription,
        'name': textName,
        'email': textEmail
      });
      

      setState((){
        loading = false;
      });

      
      var response = json.decode(data.body);

      if(response["success"] == true){
        
        clearTextInput();

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

  @override
  Widget build(BuildContext context){

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
        child: Stack(
          children: [

            Center(child: Container(
              transform: Matrix4.translationValues( MediaQuery.of(context).size.width*0.4, MediaQuery.of(context).size.height*-0.5, 0.0),
              child: Image.asset("images/hoja3.png", width: 100, height: 100),
            )),

            Container(
              
              child: Column(
                children: [

                  Column(
                    
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04, bottom: 15),
                        child: Center(
                          child: Text("Contacto", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white )) 
                        ),
                      ),

                    ],

                  ),
                  Container(
                    margin: EdgeInsets.only(top: 90),
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Column(

                          children:[


                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: buildNameField(),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: buildEmailField(),
                            ),
                            

                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: buildTextField(),
                            ),
                            
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                child: Text(
                                  "enviar".toUpperCase(),
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

                            
                                  if(!formKey.currentState.validate()){
                                    return;
                                  }

                                  formKey.currentState.save();
                                  
                                  await sendData();

                                  

                                }
                              ),
                            )
                          ] 

                        ),
                      )
                    ),
                  )

                ],
              ),
            ),
          ],
        )   
          
      )
        
      );

  }

  Widget buildTextField(){
    return Material(
      elevation: 10,
      borderRadius: new BorderRadius.circular(10.0),
      borderOnForeground: true,
      child: TextFormField(
        controller: descriptionHolder,
        keyboardType: TextInputType.text,
        maxLines: 10,
        decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white,
          isDense: true,
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding:EdgeInsets.all(15),
          hintText: "Escribe aquí",
          
          //fillColor: Colors.green
        ),
        validator: (String value){

          if(value.isEmpty){
            return 'Texto es requerido';
          }
        },
        onSaved: (String value){
          textDescription = value;
        },
      ),
    );
  }

  Widget buildEmailField(){
    return Material(
      elevation: 10,
      borderRadius: new BorderRadius.circular(10.0),
      borderOnForeground: true,
      child: TextFormField(
        controller: emailHolder,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor: Colors.white,
          isDense: true,
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding:EdgeInsets.all(15),
          labelText: "Correo electrónico",
          
          //fillColor: Colors.green
        ),
        validator: (String value){

          if(value.isEmpty){
            return 'Correo electrónico es requerido';
          }
        },
        onSaved: (String value){
          textEmail = value;
        },
      ),
    );
  }

  Widget buildNameField(){
    return Material(
      elevation: 10,
      borderRadius: new BorderRadius.circular(10.0),
      borderOnForeground: true,
      child: TextFormField(
        controller: nameHolder,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor: Colors.white,
          isDense: true,
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding:EdgeInsets.all(15),
          labelText: "Nombre",
          
          //fillColor: Colors.green
        ),
        validator: (String value){

          if(value.isEmpty){
            return 'Nombre es requerido';
          }
        },
        onSaved: (String value){
          textName = value;
        },
      ),
    );
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