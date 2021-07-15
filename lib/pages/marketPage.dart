import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:FIAN/widget/navigationDrawerWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class Market extends StatefulWidget{
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State <Market> {

  Future<List<MarketShow>> marketList;
  var loading = false;
  String selectedDepartment = "0";
  var departments = ["Seleccione un departamento-0", "Antioquia-1", "Atlantico-2", "D. C. Santa Fe de Bogotá-3", "Bolívar-4", "Boyacá-5", "Caldas-6", "Caqueta-7", "Cauca-8",
"Cesar-9",
"Cordova-10",
"Cundinamarca-11",
"Choco-12",
"Huila-13",
"La Guajira-14",
"Magdalena-15",
"Meta-16",
"Nariño-17",
"Norte de Santander-18",
"Quindio-19",
"Risaralda-20",
"Santander-21",
"Sucre-22",
"Tolima-23",
"Valle-24",
"Arauca-25",
"Casanare-26",
"Putumayo-27",
"San Andres-28",
"Amazonas-29",
"Guainia-30",
"Guaviare-31",
"Vaupes-32",
"Vichada-33"];


  Future<List<MarketShow>> getData() async {

    try{

      setState((){
        loading = true;
      });

        var data = await http.post('https://app.fiancolombia.org/api/markets', 
          body: {
            'departmentId': selectedDepartment
          }
        );

      setState((){
        loading = false;
      });

        var jsonData = json.decode(data.body);
        List<MarketShow> markets = [];
    
        for(var u in jsonData["markets"]){

          MarketShow market = MarketShow(u["id"], u["department"]["name"], u["name"], u["district"], u["address"], u["schedule"]);
          markets.add(market);
        }
  
        return markets;

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
  void initState(){
    
    super.initState();
    
    var markets = getData();
    setState((){
      marketList = markets;
    });

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
      body: Column(
        children: [
          /*Center(child: Container(
            transform: Matrix4.translationValues( MediaQuery.of(context).size.width*0.4, MediaQuery.of(context).size.height*-0.5, 0.0),
            child: Image.asset("images/hoja3.png", width: 100, height: 100),
          )),*/

          Container(
            child: Column(
              children: [

                Column(
                  children: [
                    CustomPaint(
                      painter:BluePainter(),
                      child: Stack(
                        children: [
                          Align(
                            widthFactor: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child: Image.asset("images/hoja3.png", width: 60, height: 60),
                          ),
                          Container(
                            height: 150,
                            child: Center(
                              child: Text("Mercados", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white )) 
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: DropdownButton(
                            value: selectedDepartment,
                            onChanged: (newValue) {
                              setState(() {
                                
                                selectedDepartment = newValue.toString();
                                var markets = getData();
                                setState((){
                                  marketList = markets;
                                });
                                
                              });
                            },
                            items: departments.map((value) {
                              return new DropdownMenuItem(
                                value: value.toString().substring(value.toString().indexOf("-") + 1, value.toString().length),
                                child: new Text(value.toString().substring(0, value.toString().indexOf("-"))),
                              );
                            }).toList(),
                          )

                        ),

              
                      ]
                    ),

                  ],

                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: FutureBuilder(
                      future: marketList,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.data == null && loading == true){
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child:Center(
                              child: CircularProgressIndicator(),
                            )
                          );
                        }
                        else if(snapshot.data == null && loading == true){
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child:Center(
                              child: Text("No hay mercados para mostrar"),
                            )
                          );
                        }
                        else{
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){

                              return Container(
                                
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Center(child: Text(snapshot.data[index].district+" - "+snapshot.data[index].department, style: GoogleFonts.montserrat(fontSize: 14),)),
                                      Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.store_mall_directory_outlined),
                                                    Text(snapshot.data[index].name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))
                                                  ],
                                                )
                                              ),
                                              Center(
                                                heightFactor: 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.location_on_outlined),
                                                    Text(snapshot.data[index].address)
                                                  ],
                                                )
                                              ),
                                              Center(
                                                heightFactor: 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.calendar_today_outlined),
                                                    Text(snapshot.data[index].schedule)
                                                  ],
                                                )
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                      )
                                    ] ,
                                  ),
                                );
                            },
                          );
                        }
                        
                      }
                  ),
                    ),
                )

              ],
            ),
          ),
        ],
      )
              
    
        
      );

  }

}

class MarketShow {
  final int id;
  final String department;
  final String name;
  final String address;
  final String district;
  final String schedule;

  MarketShow(this.id, this.department, this.name, this.district, this.address, this.schedule);

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
      path_0.moveTo(0,size.height);
      path_0.quadraticBezierTo(size.width*0.0327750,size.height*0.7393000,size.width*0.1815000,size.height*0.7518000);
      path_0.quadraticBezierTo(size.width*0.3861250,size.height*0.7509125,size.width,size.height*0.7482500);
      path_0.lineTo(size.width,0);
      path_0.lineTo(0,0);
      path_0.lineTo(0,size.height);
      path_0.close();
     
      canvas.drawPath(path_0, paint);

    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate){
      return oldDelegate != this;
    }
}