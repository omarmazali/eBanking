import 'package:flutter/material.dart';
import 'package:untitled/screens/creanceScreen.dart';
import 'package:untitled/screens/detailScreen.dart';
import 'package:untitled/screens/home.dart';
import 'package:untitled/screens/login.dart';

import 'models/detail.dart';

void main() {
  runApp(eBanking());
}

class eBanking extends StatelessWidget {
  const eBanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Login(),
        'Home': (context) => Home(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/Creance') {
          final String creancierID = settings.arguments as String;
          final String creancierName = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CreanceScreen(creancierID: creancierID, creancierName: creancierName,),
          );
        } else if(settings.name == '/Forms'){
          final String creanceID = settings.arguments as String;
          final String creancierName = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CreanceScreen(creancierID: creanceID, creancierName: creancierName,),
          );
        } else if(settings.name == 'Detail'){
          final DetailArguments args = settings.arguments as DetailArguments;
          return MaterialPageRoute(
            builder: (context) => Detail(
              creancierName: args.creancierName,
              creanceName: args.creanceName,
              debiteurName: args.debiteurName,
              dateCreance: args.dateCreance,
              selectedImpayes: args.selectedImpayes,
            ),
          );
        }
        return null;
      },
    );
  }
}
