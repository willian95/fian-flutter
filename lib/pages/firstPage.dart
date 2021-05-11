import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:date_util/date_util.dart';
import 'package:localstorage/localstorage.dart';

final storage = new LocalStorage('events.json');

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  

  bool loading = false;
  var localEvents = [];
  int moonPhaseIndex = 0;
  var events = [];
  List moonPhases = ["nueva","creciente","llena", "menguante"];
  int currentMonth = 0;
  int currentYear = 0;
  int currentDay = 0;

  @override
  void initState(){

    super.initState();
    var now = DateTime.now();
   
    this.currentMonth = now.month;
    this.currentYear = now.year;
    this.currentDay = now.day;

    
    checkForLocalStorageExistence(this.currentYear, this.currentMonth, this.currentDay, "now", true, true);
    

    
  }


  checkForLocalStorageExistence(year, month, day, time, setCurrentTime, showLoading) async{
    

    if(this.currentMonth == month){

      setState(() {
        loading = true;
      });

       await storage.ready; 
      if(await storage.getItem("events") != null && this.currentMonth == month){

        //var todayEvent = await db.collection('events').get();
        var todayEvent = await storage.getItem("events");
        var todayStringId = dateToStringConversion(year, month, day);
        var exists = false;
        for(var i = 0; i < todayEvent.length; i++){
            if(todayEvent[i]["date"] == todayStringId){ 
              exists = true;
            }

        }
         
        if(exists == true){
         
          this.setLocalStoredEvents(year, month, day, todayEvent, setCurrentTime, showLoading);
        }else{
          setState(() {
            loading = false;
          });
          getEvents(year, month, day, setCurrentTime, showLoading);

        }

      }else{
        getEvents(this.currentYear, this.currentMonth, this.currentDay, setCurrentTime, showLoading);
      }

    }
    else if(this.currentMonth != month){
      getEvents(year, month, day, false, false);
    }

  }


  getEvents(year, month, day, setDate, showLoading) async {


    setState(() {
      loading = true;
    });

    
    var data = await http.get('https://fian.sytes.net/api/events'+"/"+month.toString()+"/"+year.toString());
    var newEvents = json.decode(data.body);

    setState(() {
      loading = false;
    });

    var currentDate = new DateTime(this.currentYear, this.currentMonth, this.currentDay);
  

    if(this.currentMonth ==  month)
    {
      await storage.ready;
      await storage.setItem("events", newEvents);
    }
    
    setState(() {
      this.events = newEvents;

    });

    if(setDate == true){
      for(var i = 0; i < this.events.length; i++){

        if(this.events[i]["date"] == dateToStringConversion(currentDate.year, currentDate.month, currentDate.day)){
          
          Timer(Duration(seconds: 2), () => _eventCarouselController.animateToPage(i, duration: Duration(seconds: 1)));
     
        }
      }
    }else{

      var datedate = new DateTime(year, month, day);
      var currentDate = new DateTime(this.currentYear, this.currentMonth, this.currentDay);
      if(datedate.isAfter(currentDate)){
        Timer(Duration(seconds: 1), () => _eventCarouselController.jumpToPage(0));
      }else{

        Timer(Duration(seconds: 1), () => _eventCarouselController.jumpToPage(events.length - 1));

      }


    }
      
  } 

  getApiWeather(){

    //var data = await http.get('https://fian.sytes.net/api/events'+"/"+month.toString()+"/"+year.toString());
    //var newEvents = json.decode(data.body);

  }

  dateToStringConversion(year, month, day){
    var tempDay = "";
    var tempMonth = "";
    if(day < 10){
      tempDay = "0"+day.toString();
    }else{
      tempDay = day.toString();
    }

    if(month < 10){
      tempMonth = "0"+month.toString();
    }else{
      tempMonth = month.toString();
    }

    var todayStringId = year.toString()+"-"+tempMonth+"-"+tempDay;
    return todayStringId;
  }

  setLocalStoredEvents(year, month, day, items, setCurrentTime, showLoading){

    var currentDate = new DateTime(this.currentYear, this.currentMonth, this.currentDay);


      for(var j = 0; j < items.length; j++){
          this.localEvents.add(items[j]);
      
      }


    setState(() {
        loading = false;
      });

    setState((){
      this.events = this.localEvents;
    });

    
    
    if(setCurrentTime == true){
      for(var i = 0; i < this.events.length; i++){

        if(this.events[i]["date"] == dateToStringConversion(currentDate.year, currentDate.month, currentDate.day)){
          
          Timer(Duration(seconds: 2), () => _eventCarouselController.animateToPage(i, duration: Duration(seconds: 1)));
        }
      }
    }
    

  }

  isDuplicated(localEvents, date){

    var exists = false;
    for(var i = 0; i < localEvents.length; i++){
   
      if(localEvents[i]["date"] == date){
        exists = true;
        break;
      }

    }

    return exists;

  }


  dateToString(date){

    var months = [
      "enero",
      "febrero",
      "marzo",
      "abril",
      "mayo",
      "junio",
      "julio",
      "agosto",
      "septiembre",
      "octubre",
      "noviembre",
      "diciembre"
    ];

    var month = date.substring(5, 7);
    var day = date.substring(8, 10);
    return months[int.parse(month) - 1]+" "+day;

  }

  Widget _buildNewTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
     
      child: child,
    );
  }

  final CarouselController _buttonCarouselController = CarouselController();
  final CarouselController _eventCarouselController = CarouselController();

  Widget nextButton = TextButton(
    child: Text("Sí, cargar"),
    onPressed:  () {



    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: ListView(

          children: [

            this.loading == true ? (
              Center(child: CircularProgressIndicator())
            ) : (
              events.length == 0 ? (
                 Center(
                   child: Column(
                     children:[
                       Image.asset("images/sad.png", width: 60, height: 60),
                       Text("Aún no hay actividades, revisa tu conexión a internet")
                     ]
                   )
                  )
              ) : (

                Container(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: <Widget>[

                    new CarouselSlider(
                      carouselController: _buttonCarouselController,
                      options: CarouselOptions(
                        height: 100,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason){
                          if(reason == CarouselPageChangedReason.manual){
                            _buttonCarouselController.animateToPage(this.moonPhaseIndex);
                          }
                        }
                      ),
                      items: moonPhases.map((data) {
                        
                        return Container(
                          child: Column(
                            children: [
                              Image.asset("images/"+data+".png", width: 60.0, height: 60.0),
                              Center(
                                child: Text("Luna "+data, style: TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        );
                        
                      }).toList(),
                    ),

                  
                    new CarouselSlider(
                      carouselController: _eventCarouselController,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height *0.7,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {

                          setState(() {
                            
                            var moonPhase = this.events[index]["moon_phase"];
                            var moonPhaseIndex = this.moonPhases.indexOf(moonPhase);
                            this.moonPhaseIndex = moonPhaseIndex;

                            _buttonCarouselController.animateToPage(moonPhaseIndex);

                            
                          
                          });

                          var indexDay = int.parse(this.events[index]["date"].toString().substring(8, 10));
                          var indexMonth = int.parse(this.events[index]["date"].toString().substring(5, 7));
                          var indexYear = int.parse(this.events[index]["date"].toString().substring(0, 4));
                          var indexDate = new DateTime(indexYear, indexMonth, 7);

                          var dateUtility = DateUtil();
                          var lastDay = dateUtility.daysInMonth(indexDate.month, indexDate.year);
                          
                          if(reason == CarouselPageChangedReason.manual){
                            if(indexDay < 2){
                                
                              AlertDialog alert = AlertDialog(
                                title: Text("¿Desea cargar el mes anterior?"),
                                actions: [
                                  TextButton(
                                    child: Text("No, cancelar"),
                                    onPressed:  () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Sí, cargar"),
                                    onPressed:  () {

                                      var newDate = new DateTime(indexYear, indexMonth - 1, 7);
                                      checkForLocalStorageExistence(newDate.year, newDate.month, newDate.day, "old", true, false);
                                      Navigator.pop(context);

                                    },
                                  ),
                                ],
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );

                            }

                            else if(indexDay == lastDay){
                              
                              AlertDialog alert = AlertDialog(
                                title: Text("¿Desea cargar el mes siguiente?"),
                                actions: [
                                  TextButton(
                                    child: Text("No, cancelar"),
                                    onPressed:  () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Sí, cargar"),
                                    onPressed:  () {

                                      var newDate = new DateTime(indexYear, indexMonth + 1, 7);
                                      checkForLocalStorageExistence(newDate.year, newDate.month, newDate.day, "old", true, false);
                                      Navigator.pop(context);

                                    },
                                  ),
                                ],
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                              

                            }
                          }

                        }
                      ),
                      items: events.map((data) {
                        
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(1, 3), // changes position of shadow
                                  ),
                                ]
                              ),
                              child: GestureDetector(
                                child:Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10),
                                          child: Text(dateToString(data["date"]), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: GridView.count(
                                        // Create a grid with 2 columns. If you change the scrollDirection to
                                        // horizontal, this produces 2 rows.
                                        crossAxisCount: 2,
                                        padding: EdgeInsets.all(0),
                                        childAspectRatio: 1.4,
                                        mainAxisSpacing: 2,
                                        shrinkWrap: true,
                                        // Generate 100 widgets that display their index in the List.
                                        children: List.generate(data["farm_activity_events"].length, (index) {
                                          return Center(
                                            child: Image.asset(
                                                "images/icon"+data["farm_activity_events"][index]["farm_activity_id"].toString()+".png", width: 60.0, height: 60.0,
                                            ),
                                          );
                                        }),
                                      )
                                    
                                    )
                                    
                                  ],
                                ),
                                onTap: () {

                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel, 
                                    barrierColor: Colors.transparent,
                                    transitionDuration: Duration(milliseconds: 400),
                                    transitionBuilder: _buildNewTransition,
                                    pageBuilder: (BuildContext context, Animation first, Animation second){

                                      return Scaffold(
                                        appBar: AppBar(
                                          title: Text(""),
                                          backgroundColor: Colors.transparent,
                                          iconTheme: IconThemeData(color: Colors.black),
                                          elevation: 0,
                                        ),
                                        body: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: data["farm_activity_events"].length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 5,
                                              margin: EdgeInsets.fromLTRB(10, 10, 15, 15),
                                              child: CustomPaint(
                                                  painter: DialogPainter(),
                                                  child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Row(
                                                      
                                                      children:[
                                                
                                                        Expanded(
                                                          flex: 1,
                                                          child: 
                                                            Image.asset("images/icon"+data["farm_activity_events"][index]["farm_activity_id"].toString()+".png", width: 60.0, height: 60.0),
                                                        
                                                        ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                               crossAxisAlignment: CrossAxisAlignment.stretch,
                                                               mainAxisAlignment: MainAxisAlignment.start,
                                                               children: [
                                                                Text(
                                                                  data["farm_activity_events"][index]["farm_activity"]["name"].toString(),
                                                                  maxLines: 10,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(fontWeight: FontWeight.bold)
                                                                ),

                                                                Text(
                                                                  data["farm_activity_events"][index]["farm_activity"]["description"].toString(),
                                                                  maxLines: 10,
                                                                  textAlign: TextAlign.justify
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                                
                                                      ]

                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                            );
                                          },
                                        ),
                                      );

                                    }
                                  );

                                }
                              )
                              
                            );
                          },
                        );

                      }).toList(),
                    )

                  
                ]
              ),
              )

              )
              
            ),
            
           
          ],

        ),
      )
    );

  }


}

class BluePainter extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      Paint paint = Paint();
      paint.color = HexColor("fdcb6e");
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


class DialogPainter extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      Paint paint = Paint();
      paint.color = HexColor("fdcb6e");
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 20;

      /*Path mainBackground = Path();
      mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
      paint.color = Colors.blue;
      canvas.drawPath(mainBackground, paint);*/

      Path customDesign = Path();
      customDesign.moveTo(0, 0);
      customDesign.lineTo(size.width * 0.33, 0);
      customDesign.lineTo(size.width * 0.33, size.height);
      customDesign.lineTo(0, size.height);
      //customDesign.lineTo(0, size.height * 0.3);
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

