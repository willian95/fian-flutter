import 'package:flutter/material.dart';
import 'package:FIAN/pages/firstPage.dart';
import 'package:FIAN/pages/marketPage.dart';
import 'package:FIAN/pages/contact.dart';
import 'package:FIAN/pages/tutorialNav.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    

    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Opacity(
        opacity: 0.95, 
        child:Drawer(
          child: Material(
            color: Color.fromRGBO(20, 78, 65, 1),
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: Column(
                children: [
                  Center(
                    child: Image.asset("images/logowhite.png", width: 120, height: 120),
                  ),

                  ListTile(
                    title: Text("CICLO LUNAR", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w800)),
                    onTap: () => selectedItem(context, 0),
                  ),
                  ListTile(
                    title: Text("LISTA DE MERCADOS", style: GoogleFonts.montserrat(color: Colors.white)),
                    onTap: () => selectedItem(context, 1),
                  ),
                  ListTile(
                    title: Text("CONTÁCTANOS", style: GoogleFonts.montserrat(color: Colors.white)),
                    onTap: () => selectedItem(context, 2),
                  ),
                  ListTile(
                    title: Text("TUTORIAL", style: GoogleFonts.montserrat(color: Colors.white)),
                    onTap: () => selectedItem(context, 3),
                  )

                ],
              ),
            ),
          )
        )
      ),
    );

    
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FirstPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Market(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Contact(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TutorialNav(),
        ));
        break;
    }
  }
}