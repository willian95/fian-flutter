import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:fian/pages/firstPage.dart';
import 'package:fian/pages/marketPage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  
  List<ScreenHiddenDrawer> itens = new List();

  @override
  void initState() {

    getToken();

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Ciclo lunar",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.teal,
        ),
        FirstPage()
      )
    );

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Mercados",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.teal,
        ),
        Market()
      )
    );

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    

    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.yellow.shade600,
      backgroundColorAppBar: Colors.transparent,
      screens: itens,
      slidePercent: 60.0,
      contentCornerRadius: 40,
      leadingAppBar: Icon(Icons.menu, color: Colors.black,),
      elevationAppBar: 0.0,
    );
    
  }

  Future <void> getToken() async {
    
    await OneSignal.shared.init("4022145e-cf18-4919-ab6e-de8f87ffe910");
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
