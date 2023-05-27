import 'dart:core';

import 'package:flutter/material.dart';

import '../../models/creancier.dart';

import '../../services/creancierSoap.dart';
import 'creanceScreen.dart';

class CreancierScreen extends StatefulWidget {

  @override
  State<CreancierScreen> createState() => _CreancierScreenState();
}

class _CreancierScreenState extends State<CreancierScreen> {

  void updateList(String value) {
    setState(() {
      display_list = creanciers
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchCreanciers() async {
    final fetchedCreanciers = await creancierSoap.fetchCreanciers();
    setState(() {
      creanciers = fetchedCreanciers;
      display_list = List.from(creanciers);
    });
  }

  List<Creancier> creanciers = [];
  List<Creancier> display_list = [];
  final CreancierSoap creancierSoap = CreancierSoap();

  @override
  void initState() {
    super.initState();
    fetchCreanciers();
  }

  void navigateToCreanceScreen(String creancierID, String creancierName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreanceScreen(creancierID: creancierID, creancierName: creancierName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextField(
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "eg: Redal",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.blue.shade900),
            ),
            Expanded(
              child: display_list.length == 0
                  ? Center(
                      child: Text(
                        "No result found",
                        style: TextStyle(
                            color: Color(0xFF146C94),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) {
                        final creancier = display_list[index];
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
                                  bottom: 1.0),
                              title: Text(creancier.name),
                              onTap: () => navigateToCreanceScreen(creancier.id, creancier.name),
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
