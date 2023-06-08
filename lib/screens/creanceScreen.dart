import 'dart:core';

import 'package:flutter/material.dart';

import '../models/creance.dart';
import '../services/creanceSoap.dart';
import 'formScreen.dart';


class CreanceScreen extends StatefulWidget {
  final String creancierID;
  final String creancierName;
  final String fname;
  final String lname;

  CreanceScreen({required this.creancierID, required this.creancierName, required this.fname, required this.lname});
  @override
  State<CreanceScreen> createState() => _CreanceScreenState();
}

class _CreanceScreenState extends State<CreanceScreen> {
  List<Creance> creances = [];
  final CreanceSoap creanceSoap = CreanceSoap();


  Future<void> fetchCreancesByCreancierID(String creancierID) async {
    final fetchedCreancesByCreacierID =
    await creanceSoap.fetchCreancesByCreancierID(creancierID);
    setState(() {
      creances = fetchedCreancesByCreacierID;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCreancesByCreancierID(widget.creancierID);
  }

  void navigateToFormScreen(String creancierID, String creancierName, String creanceName, String fname, String lname) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(creanceID: creancierID, creancierName: creancierName, creanceName: creanceName, fname: fname, lname:lname),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choisissez votre créance"),
        centerTitle: true,
        backgroundColor: Color(0xFF146C94),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: creances.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        top: 1.0,
                        right: 8.0,
                        bottom: 1.0,
                      ),
                      title: Text(creances[index].name),
                      onTap: () =>  navigateToFormScreen(creances[index].id, creances[index].name, widget.creancierName, widget.fname, widget.lname),

                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
