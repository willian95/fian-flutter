import 'package:flutter/material.dart';
import 'package:fian/pages/phoneConfiguration.dart';
import 'package:fian/pages/home.dart';
import 'package:fian/pages/tutorial.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';

final storage = new LocalStorage('events.json');

void main() => runApp(MaterialApp(

  theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.blue),
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),

));

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State <SplashScreen> {

  @override
  void initState(){
    
    super.initState();
    Timer(Duration(seconds: 3), (){
      
      gotoPage();

    });
  }

  void gotoPage() async{

    await storage.ready; 
    var numberStored = await storage.getItem("numberstored");
    var tutorialStored = await storage.getItem("tutorialstored");

    if(numberStored == "true" && tutorialStored == "true"){
       Navigator.push(context, new MaterialPageRoute(
        builder: (context) => Home()
      ));
    }

    else if(numberStored == "true"){
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => Tutorial()
      ));
    }

    else{
      Navigator.push(context, new MaterialPageRoute(
        builder: (context) => PhoneConfiguration()
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
            decoration: BoxDecoration(color: Colors.yellow.shade600),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image.asset("images/agriculture.png", width: 50, height: 50,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "FIAN", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24.0, 
                          fontWeight: FontWeight.bold
                        )
                      )
                    ],
                  ),
                )
              ),
              Expanded(
                flex:1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0)
                    ),
                    
                  ],
                )
              )

            ],
          )
        ],
      ),
    );


  }

}