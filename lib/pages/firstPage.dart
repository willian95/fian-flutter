import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:date_util/date_util.dart';
import 'package:localstorage/localstorage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:FIAN/widget/navigationDrawerWidget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:lottie/lottie.dart';

final storage = new LocalStorage('events.json');
enum AniProps { x, y }

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  
  final _tween = TimelineTween<AniProps>()
    ..addScene(begin: Duration(seconds: 0), end: Duration(seconds: 4))
        .animate(AniProps.y, tween: (0.0).tweenTo(100.0))
        .animate(AniProps.y, tween: (100.0).tweenTo(0.0));

  bool loading = false;
  var localEvents = [];
  var dailyText = "";
  int moonPhaseIndex = 0;
  DateTime selectedDate;
  var events = [];
  List moonPhases = ["nueva","creciente","llena", "menguante", "llena_equinoccio_otoño", "llena_equinoccio_primavera", "llena_solsticio_invierno", "llena_solsticio_verano", "nueva_equinoccio_otoño", "nueva_equinoccio_primavera", "nueva_solsticio_invierno", "nueva_solsticio_verano", "creciente_equinoccio_otoño", "creciente_equinoccio_primavera", "creciente_solsticio_invierno", "creciente_solsticio_verano", "menguante_equinoccio_otoño", "menguante_equinoccio_primavera", "menguante_solsticio_invierno", "menguante_solsticio_verano"];
  int currentMonth = 0;
  int currentYear = 0;
  int currentDay = 0;
  String mainWeather = "";
  ScrollController _scrollController;
  GlobalKey containerKey = GlobalKey();
  double dailyTextPosition = 0;
  bool showDownArrow = true;

  @override
  void initState(){
    
    super.initState();
    
    
    var now = DateTime.now();
    this.selectedDate = now;
    this.currentMonth = now.month;
    this.currentYear = now.year;
    this.currentDay = now.day;
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    this.getDailyText(currentDay < 10 ? "0"+currentDay.toString() : currentDay.toString(), currentMonth < 10 ? "0"+currentMonth.toString() : currentMonth.toString(), currentYear.toString());

    checkForLocalStorageExistence(this.currentYear, this.currentMonth, this.currentDay, "now", true, true);
    climateAPI();

    //_scrollController.addListener(_scrollListener);
    _scrollController.addListener(() {
      //print(_scrollController.position.pixels);

      double currentPosition = _scrollController.position.pixels;

      double height = MediaQuery.of(context).size.height;
      double tempPosition = (dailyTextPosition - height) + 100;


      /*  setState(
            (){
              showDownArrow = true;
            }
          );

        if(currentPosition > tempPosition){
          setState(
            (){
              showDownArrow = false;
            }
          );
        }*/
      
      });

    }

  getDailyText(day, month, year) async{

    var data = await http.get('https://app.fiancolombia.org/api/daily-text?date='+day.toString()+"/"+month.toString()+"/"+year.toString());
    var res = json.decode(data.body);
    setState((){
      dailyText = res["text"];
    });

    Timer(Duration(seconds: 3), (){
      
      RenderBox box = containerKey.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset.zero); //this is global position
      dailyTextPosition = position.dy;
      
    });

    

  }

  _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(
      locale : const Locale("es","ES"),
      context: context,
      initialDate: selectedDate,// Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        this.currentMonth = selectedDate.month;
        this.currentYear = selectedDate.year;
        this.currentDay = selectedDate.day;
        checkForLocalStorageExistence(selectedDate.year, selectedDate.month, selectedDate.day, "old", true, false);
    });
}

  checkForLocalStorageExistence(year, month, day, time, setCurrentTime, showLoading) async{

    if(this.currentMonth == month){

      if(this.mounted){
        setState(() {
          loading = true;
        });
      }
      
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
          if(this.mounted){
            setState(() {
              loading = false;
            });
          }
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

    if (this.mounted) {
      setState(() {
        loading = true;
      });
    }

    var data = await http.get('https://app.fiancolombia.org/api/events'+"/"+month.toString()+"/"+year.toString());
    var newEvents = json.decode(data.body);


    var currentDate = new DateTime(this.currentYear, this.currentMonth, this.currentDay);
  

    if(this.currentMonth ==  month)
    {
      await storage.ready;
      await storage.setItem("events", newEvents);
    }
    if (this.mounted) {
      setState(() {
        this.events = newEvents;
        loading = false;
      });
    }

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

  climateAPI(){
    _determinePosition();
  }
  
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AlertDialog alert = AlertDialog(
          title: Text("El acceso al GPS ha sido rechazado, por lo tanto no se podrá actualizar el clima")
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      
      AlertDialog alert = AlertDialog(
        title: Text("El acceso al GPS ha sido rechazado para siempre")
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
       
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    var location = await Geolocator.getCurrentPosition();
    weatherAPICall(location);
    
  }

  setWeather(year, month, day) async{

    await storage.ready;
    var weather = await storage.getItem("weather");

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

    if (this.mounted) {
      setState((){
            
        mainWeather = "";

      });
    }

    if(this.currentDay == day && this.currentMonth == month && this.currentYear == year){
      if (this.mounted) {
        setState((){
            
          mainWeather = weather[0]["weather"][0]["main"];

        });
      }
    }else{
 
      for(var i = 0; i < weather.length; i++){

        if(weather[i]["dt_txt"].toString().substring(0, 10) == year.toString()+"-"+tempMonth+"-"+tempDay){
          
          if(weather[i]["dt_txt"].toString().contains("12:")){

            if(this.mounted){
              setState((){
              
                mainWeather = weather[i]["weather"][0]["main"];

              });
            }
            

          }

        }

      }

    }

    print("mainWeather");
    print(mainWeather);
  

  }

  weatherAPICall(location) async{

    print("mainLocation");
    print(location);

    var data = await http.get("https://api.openweathermap.org/data/2.5/forecast?lat="+location.latitude.toString()+"&lon="+location.longitude.toString()+"&appid=d816b2362dc0ff9fc94670863e1505d9");
    var weatherData = json.decode(data.body);

    if(this.mounted){
      setState((){
        mainWeather = weatherData["list"][0]["weather"][0]["main"];
      });
    }


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

    if(this.mounted){
    setState(() {
        loading = false;
      });
    }

    if(this.mounted){
    setState((){
      this.events = this.localEvents;
    });
    }

    
    
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

  scrollToPoint(offset){

    _scrollController.animateTo(offset, duration: new Duration(seconds: 2), curve: Curves.ease);

  }


  dateToString(date){

    var months = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];

    var month = date.substring(5, 7);
    var day = date.substring(8, 10);
    return months[int.parse(month) - 1]+" "+day;

  }


  showActivityModal(id, title, description, best_season){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20.0)),
            child: Container(
            constraints: BoxConstraints(maxHeight: 500),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 35,
                                ),
                              ),
                            ]
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Image.asset(
                              "images/icon"+id.toString()+".png", width: 100, height: 100
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(7, 0, 7, 20),
                            child: Text(
                              title.toUpperCase(),
                              overflow: TextOverflow.fade,
                              maxLines: 10,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18)
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              description,
                              textAlign: TextAlign.justify,
                              softWrap: true,
                            ),
                          
                          ),
                          
                         
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    });
                                                
  }

  final CarouselController _eventCarouselController = CarouselController();


  @override
  Widget build(BuildContext context) {
    
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerScrimColor: Colors.transparent,
      drawer:NavigationDrawerWidget(),
      key:scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(""),
        leading: IconButton(
          icon: Image.asset('images/menu.png', width: 20, height: 20), 
          onPressed: () => scaffoldKey.currentState.openDrawer()
        ),
      ),
      body: WillPopScope(
          
          onWillPop: () async { return false; },
          child: Stack(
          children: [
            if(events.length > 0 && loading == false)
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topLeft,
                    image: AssetImage("images/"+mainWeather.toLowerCase()+".gif"),
                    fit: BoxFit.fill
                  ),
              ),
            ),
            Container(
              color: Color.fromRGBO(20, 78, 65, 0.4),
            ),
            
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                child: Column(
                  
                  children: [

                    this.loading == true ? (
                      Center(child: CircularProgressIndicator())
                    ) : (
                      events.length == 0 && this.loading == false ? (
                         Center(
                           child: Column(
                             children:[
                               Image.asset("images/sad.png", width: 60, height: 60),
                               Text("Aún no hay actividades", style: GoogleFonts.montserrat(color: Colors.white)),
                               Center(
                                 child: ElevatedButton(
                                    child: Text(
                                      "Volver al mes actual".toUpperCase(),
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
                                    onPressed: () {

                                      var now = DateTime.now();
                                      this.selectedDate = now;
                                      this.currentMonth = now.month;
                                      this.currentYear = now.year;
                                      this.currentDay = now.day;

                                      getEvents(now.year, now.month, now.day, true, false);
                                    }
                                  ),
                                )
                             ]
                           )
                          )
                      ) : (

                        Container(
                        
                        child: CustomPaint(
                          painter: RoundedBorder(),
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            
                              children: <Widget>[

                                new CarouselSlider(
                                  carouselController: _eventCarouselController,
                                  options: CarouselOptions(
                                    height: 670,
                                    initialPage: 0,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    autoPlay: false,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    scrollPhysics: ScrollPhysics(),
                                    onPageChanged: (index, reason) {
                                      
                                      if(this.mounted){

                                        var indexDay = int.parse(this.events[index]["date"].toString().substring(8, 10));
                                        var indexMonth = int.parse(this.events[index]["date"].toString().substring(5, 7));
                                        var indexYear = int.parse(this.events[index]["date"].toString().substring(0, 4));
                                        var indexDate = new DateTime(indexYear, indexMonth, 7);
                                        var dateUtility = DateUtil();
                                        this.selectedDate = new DateTime(indexYear, indexMonth, indexDay);
                                        var lastDay = dateUtility.daysInMonth(indexDate.month, indexDate.year);
                                      
                                        if(reason == CarouselPageChangedReason.manual){
                                          if(indexDay < 2){
                                              
                                            AlertDialog alert = AlertDialog(
                                              title: Text("¿Desea cargar el mes anterior?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("No, cancelar"),
                                                  onPressed:  () {
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Sí, cargar"),
                                                  onPressed:  () {

                                                    var newDate = new DateTime(indexYear, indexMonth - 1, 7);
                                                    checkForLocalStorageExistence(newDate.year, newDate.month, newDate.day, "old", true, false);
                                                    Navigator.of(context, rootNavigator: true).pop();

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
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Sí, cargar"),
                                                  onPressed:  () {

                                                    var newDate = new DateTime(indexYear, indexMonth + 1, 7);
                                                    checkForLocalStorageExistence(newDate.year, newDate.month, newDate.day, "old", true, false);
                                                    Navigator.of(context, rootNavigator: true).pop();

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
                                    }
                                  ),
                                  items: events.map((data) {
                                    
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onVerticalDragUpdate:(info){
                                            //print("info");
                                            //print(info);
                                            var array = info.toString().split(",");
                                            var position = array[1].toString().replaceAll(")", "");
                                           
                                            scrollToPoint(double.parse(position) + 250);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 70),
                                            child: Column(
                                              children: [
                                                Container(
                                                  
                                                  transform: Matrix4.translationValues( 0, -60, 0.0),
                                                  child:Center(
                                                    child: Text("LUNA "+data["moon_phase"].toString().toUpperCase().replaceAll("_", " "), style:GoogleFonts.montserrat(color: HexColor("#144E41"), fontWeight: FontWeight.bold, fontSize: 15))
                                                    )
                                                ),
                                                Container(

                                                  decoration: new BoxDecoration(
                                                    boxShadow: [
                                                      new BoxShadow(
                                                        color: Colors.grey.withOpacity(0.2),
                                                        spreadRadius: 1,
                                                        blurRadius: 7,
                                                        offset: Offset(1, 0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25.0),
                                                    ),
                                                    elevation: 0,
                                                    child: Column(
                                                      children: [
                                                        
                                                        Container(
                                                          
                                                          transform: Matrix4.translationValues( 0, -60, 0.0),
                                                          width: 90,
                                                          height: 90,
                                                          child: Neumorphic(
                                                            style: NeumorphicStyle(
                                                              shape: NeumorphicShape.concave,
                                                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)), 
                                                              depth: -4,
                                                              shadowLightColor: Colors.grey.shade600,
                                                              intensity: 0.5,
                                                              surfaceIntensity: 0.2,
                                                              lightSource: LightSource.bottom,
                                                              color: Colors.white
                                                            ),
                                                            child:Container(
                                                              child: Center(
                                                                child: Image.asset("images/"+data["moon_phase"]+".png", width: 60, height: 60),
                                                              ),
                                                            )
                                                          ),
                                                        ),
                                                       
                                                        Container(
                                                          transform: Matrix4.translationValues( 0, -40, 0.0),
                                                          margin: EdgeInsets.only(bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(dateToString(data["date"]).toString().toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20.0)),
                                                              new Theme(
                                                               data: ThemeData.light().copyWith(
                                                                    primaryColor: const Color(0xFF8CE7F1),
                                                                    accentColor: const Color(0xFF8CE7F1),
                                                                    colorScheme: ColorScheme.light(primary: HexColor("#144E41")),
                                                                    buttonTheme: ButtonThemeData(
                                                                      textTheme: ButtonTextTheme.primary
                                                                    ),
                                                                ),
                                                                child: new Builder(
                                                                  builder: (context) => new GestureDetector(
                                                                    
                                                                    onTap: () => _selectDate(context),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 15.0),
                                                                      child: Icon(
                                                                        Icons.calendar_today,
                                                                        color: Colors.grey,
                                                                        size: 25.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ) 
                                                              ),
                                                            ],
                                                          )
                                                        ),
                                                        Container(
                                                          transform: Matrix4.translationValues( 0, -40, 0.0),
                                                          child: GridView.count(
                                                            // Create a grid with 2 columns. If you change the scrollDirection to
                                                            // horizontal, this produces 2 rows.
                                                            crossAxisCount: 2,
                                                            padding: EdgeInsets.all(0),
                                                            childAspectRatio: 1.2,
                                                            mainAxisSpacing: 0,
                                                            shrinkWrap: true,
                                                            // Generate 100 widgets that display their index in the List.
                                                            children: List.generate(data["farm_activity_events"].length, (index) {
                                                              return GestureDetector(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                   
                                                                    border: Border(
                                                                     
                                                                      right: BorderSide( //                   <--- left side
                                                                        color: Colors.grey,
                                                                        width: 0.2,
                                                                      ),
                                                                      bottom: ( data["farm_activity_events"].length == 4 && (index == 0 || index == 1) || data["farm_activity_events"].length >= 5 && (index == 0 || index == 1 || index == 2 || index == 3)) ? BorderSide( //                   <--- left side
                                                                        color: Colors.grey,
                                                                        width: 0.2,
                                                                      ) : BorderSide( color: Colors.white, width: 0.0),
                                                                
                                                                    ),
                                                                    
                                                                  ),
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Center(
                                                                    child: Column(
                                                                      children:[
                                                                        Image.asset(
                                                                          "images/icon"+data["farm_activity_events"][index]["farm_activity_id"].toString()+".png", width: 70, height: 70.0,
                                                                        ),
                                                                        Container(
                                                                          margin:EdgeInsets.only(top: 15),
                                                                          child: Text(data["farm_activity_events"][index]["farm_activity"]["name"].toString().toUpperCase()+" "+data["farm_activity_events"].length.toString()+" "+index.toString(), textAlign: TextAlign.center, style: GoogleFonts.montserrat(
                                                                            fontSize: 10, fontWeight: FontWeight.bold
                                                                          )),
                                                                        )
                                                                          
                                                                      ]
                                                                    )
                                                                  ),
                                                                ),
                                                                onTap: () => {

                                                                  showActivityModal(data["farm_activity_events"][index]["farm_activity_id"], data["farm_activity_events"][index]["farm_activity"]["name"], data["farm_activity_events"][index]["farm_activity"]["description"], data["farm_activity_events"][index]["farm_activity"]["best_season"])
                                                                  
                                                                },
                                                                onVerticalDragUpdate:(info){
                                                                  
                                                                  //print(info);
                                                                  var array = info.toString().split(",");
                                                                  var position = array[1].toString().replaceAll(")", "");
                                                                
                                                                  scrollToPoint(double.parse(position) + 250);
                                                                },
                                                                
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 20.0),
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child: Text("Desliza para más información", style: GoogleFonts.montserrat(color: HexColor("#144E41"), fontWeight: FontWeight.bold)),
                                                              ),
                                                              Lottie.asset('images/arrow_down_black.json', width: 50, height: 50)
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                  }).toList(),
                                ),
                                
                                dailyText != "" ? Container(
                                  key: containerKey,
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    color: HexColor("#144E41"),
                                    elevation: 2,
                                    child: Stack(
                                      children: [
                                        Opacity(
                                          opacity: 0.2,
                                          child: Image.asset("images/hoja1.png", width: 180, height: 180)
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children:[
                                              Container(
                                                margin: EdgeInsets.only(top: 10, bottom: 15),
                                                child: Image.asset("images/information-button.png", width: 40, height: 40)
                                              ),
                                              Center(
                                                child: Text(dailyText.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  
                                                )),
                                              )
                                            ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ) : Text(""),



                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 10),
                                  width: MediaQuery.of(context).size.width,
                                  color: HexColor("#144E41"),
                                  child: Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            transform: Matrix4.translationValues( 40,-30, 0.0),
                                            child: Image.asset("images/hoja3.png", width: 80, height: 80)
                                          )
                                        ],
                                      ),
                                      Text("¡Por el derecho humano a la alimentación y nutrición adecuadas y la soberanía alimentaria!".toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 10
                                      ),),
                                    ],
                                  )
                                )
                              
                            ]
                      ),
                          ),
                        ),
                      )

                      )
                      
                    ),
                    
                   
                  ],

                ),
              ),
            ),
          ],
          ),
      ),
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

class RoundedBorder extends CustomPainter{

    @override
    void paint(Canvas canvas, Size size){
      Paint paint = Paint();
      paint.color = HexColor("ffffff");
      paint.style = PaintingStyle.fill;

      Path path_0 = Path();
      path_0.moveTo(0,100);
      path_0.quadraticBezierTo(size.width*0.0299750,size.height*0.015000,size.width*0.4375000,size.height*0.0150000);
      path_0.quadraticBezierTo(size.width*0.5786500,size.height*0.0150000,size.width,size.height*0.0150000);
      path_0.lineTo(size.width,size.height);
      path_0.lineTo(0, size.height);
      path_0.close();
      
      canvas.drawPath(path_0, paint);

    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate){
      return true;
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

