import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:FIAN/pages/firstPage.dart';
import 'package:FIAN/pages/marketPage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:FIAN/widget/navigationDrawerWidget.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
 

  @override
  void initState() {

    getToken();

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      drawer:NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text("FIAN"),
      ),
    );
    
  }

  Future <void> getToken() async {
    
    await OneSignal.shared.init("841cfb24-eebf-49b1-8015-e18b490e278a");
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      //this.setState(() {
        
        print("Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      //});
    });
    
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
     // this.setState(() {
        
          print("Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      //});
    });


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
