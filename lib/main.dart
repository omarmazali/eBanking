import 'package:flutter/material.dart';
import 'package:untitled/screens/creanceScreen.dart';
import 'package:untitled/screens/detailScreen.dart';
import 'package:untitled/screens/home.dart';
import 'package:untitled/screens/login.dart';
import 'package:untitled/screens/pwdScreen.dart';
import 'package:untitled/screens/sms.dart';

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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/Creance') {
          final String id = settings.arguments as String;
          final String tel = settings.arguments as String;
          final String creancierID = settings.arguments as String;
          final String creancierName = settings.arguments as String;
          final String fname = settings.arguments as String;
          final String lname = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CreanceScreen(id: id, tel:tel,creancierID: creancierID, creancierName: creancierName,fname: fname,lname: lname,),
          );
        } else if(settings.name == '/Home') {
          final String username = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Home(username: username),
          );
        }else if(settings.name == '/Forms'){
          final String id = settings.arguments as String;
          final String tel = settings.arguments as String;
          final String creanceID = settings.arguments as String;
          final String creancierName = settings.arguments as String;
          final String fname = settings.arguments as String;
          final String lname = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CreanceScreen(id:id, tel:tel, creancierID: creanceID, creancierName: creancierName,fname: fname,lname: lname,),
          );
        } else if(settings.name == 'SMS'){
          final DetailArguments args = settings.arguments as DetailArguments;
          return MaterialPageRoute(
            builder: (context) => SMS(
              id: args.id,
              selectedImpayes: args.selectedImpayes,
              tel: args.tel,
            ),
          );
        }else if(settings.name == 'Detail'){
          final DetailArguments args = settings.arguments as DetailArguments;
          return MaterialPageRoute(
            builder: (context) => Detail(
              id: args.id,
              tel: args.tel,
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
