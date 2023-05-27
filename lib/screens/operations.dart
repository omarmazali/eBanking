import 'dart:core';

import 'package:flutter/material.dart';

import '../models/facture_model.dart';

class Operations extends StatefulWidget {
  @override
  State<Operations> createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {

  static List<FactureModel> facture_mars = [
    FactureModel("Recharge IAM", "20 DH",
        "31 avr.", "-20 DH"),
    FactureModel("Recharge IAM", "20 DH",
        "12 avr.", "-20 DH"),
    FactureModel("Recharge IAM", "20 DH",
        "01 avr.", "-20 DH"),
  ];

  List display_mars = List.from(facture_mars);

  void updateList(String value) {
    setState(() {
      display_mars = facture_mars
          .where((element) => element.facture_title!
          .toLowerCase()
          .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Expanded(
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
                    hintText: "eg: RADEMA",
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.blue.shade900),
              ),
              Expanded(
                  child: display_mars.length == 0
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
                    itemCount: display_mars.length,
                    itemBuilder: (context, index) => Card(
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
                          contentPadding: EdgeInsets.only(left: 20.0, right: 8.0),
                          title: Text(
                            display_mars[index].facture_title!,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${display_mars[index].facture_creance!}',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '${display_mars[index].next_page!}',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              '${display_mars[index].facture_url!}',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

