import 'package:flutter/material.dart';
import 'package:FIAN/pages/welcomePage.dart';
import 'package:FIAN/pages/phoneConfiguration.dart';
import 'package:FIAN/pages/home.dart';
import 'package:FIAN/pages/tutorial.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:async';

final storage = new LocalStorage('events.json');

enum AniProps { x, y }

void main() => runApp(MaterialApp(
  
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    const Locale('es', 'ES'), // Spanish, no country code
  ],
  theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.blue),
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),

));

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State <SplashScreen> {

  final _tween = TimelineTween<AniProps>()
    ..addScene(begin: Duration(seconds: 0), end: Duration(seconds: 4))
        .animate(AniProps.y, tween: (-100.0).tweenTo(100.0));

  final _tween2 = TimelineTween<AniProps>()
    ..addScene(begin: Duration(seconds: 0), end: Duration(seconds: 4))
        .animate(AniProps.y, tween: (100.0).tweenTo(0));

  @override
  void initState(){
    
    super.initState();
    Timer(Duration(seconds: 3), (){
      
      getToken();
      gotoPage();

    });
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


  void gotoPage() async{

    await storage.ready; 
    var numberStored = await storage.getItem("numberstored");
    var tutorialStored = await storage.getItem("tutorialstored");
    var welcomeStored = await storage.getItem("welcomeStored");
    var entered = false;


    if(welcomeStored == "true" && entered == false){
      entered = true;
       Navigator.push(context, new MaterialPageRoute(
        builder: (context) => PhoneConfiguration()
      ));

    }else if(entered == false){
      
      entered = true;
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => WelcomePage()
      ));
    }

    if(numberStored == "true" && entered == false){
      entered = true;
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => Tutorial()
      ));
    }else if(entered == false){
      entered = true;
       Navigator.push(context, new MaterialPageRoute(
        builder: (context) => PhoneConfiguration()
      ));
    }

    if(tutorialStored == "true" && entered == false){
      entered = true;
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => Home()
      ));
    }else if(entered == false){
        entered = true;
       Navigator.push(context, new MaterialPageRoute(
        builder: (context) => Tutorial()
      ));
    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: HexColor("#144E41")),
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  LoopAnimation<TimelineValue<AniProps>>(
                    tween: _tween, // Pass in tween
                    duration: _tween.duration, // Obtain duration
                    builder: (context, child, value) {
                      return Transform.translate(
                        offset: Offset(30, value.get(AniProps.y)),
                        child: Image.asset("images/hoja1.png", width: 180, height: 180)
                      );
                    }
                  )
                  
                  
                  
                ],
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Calendario", style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        
                      )),
                      Text("Agropecuario", style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: Colors.white,
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      
                    ],
                  ),
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LoopAnimation<TimelineValue<AniProps>>(
                    tween: _tween2, // Pass in tween
                    duration: _tween2.duration, // Obtain duration
                    builder: (context, child, value) {
                      return Transform.translate(
                        offset: Offset(0, value.get(AniProps.y)),
                        child: Image.asset("images/hoja2.png", width: 120)
                      );
                    }
                  )
                ],
              )

            ],
          ),
         
        ],
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