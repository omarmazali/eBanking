import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/screens/sms.dart';

import '../models/impaye.dart';
import 'package:http/http.dart' as http;
import '../services/soldeSoap.dart';

class Detail extends StatefulWidget {
  final String id;
  final String tel;
  final String creancierName;
  final String creanceName;
  final String debiteurName;
  final DateTime dateCreance;
  final List<Impaye> selectedImpayes;

  Detail({
    required this.id,
    required this.tel,
    required this.creancierName,
    required this.creanceName,
    required this.debiteurName,
    required this.dateCreance,
    required this.selectedImpayes,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<dynamic> getdataDetails = [];
  bool isPaymentSuccessful = false;

  @override
  void initState() {
    getdataDetails = [
      {
        "fRow": "Créancier :",
        "sRow": widget.creancierName,
      },
      {
        "fRow": "Créance :",
        "sRow": widget.creanceName,
      },
      {
        "fRow": "Débiteur :",
        "sRow": widget.debiteurName,
      },
      {
        "fRow": "Date de créance :",
        "sRow":
        "${widget.dateCreance.day}/${widget.dateCreance.month}/${widget
            .dateCreance.year}",
      },
    ];
  }

  List<dynamic> getDataRecap() {
    // Generate the recap data based on the selected impayes
    List<dynamic> recapData = [];
    double totalAmount = 0.0;
    for (var impaye in widget.selectedImpayes) {
      recapData.add({
        "Reference": impaye.id,
        "Description": impaye.name,
        "Prix TTC": "${impaye.price} DH",
      });
      double price = double.parse(impaye.price);
      totalAmount += price;
    }
    recapData.add({
      "Reference": "",
      "Description": "Total :",
      "Prix TTC": "${totalAmount.toStringAsFixed(2)} DH",
    });

    return recapData;
  }

  Color getColor(Set<MaterialState> states) {
    return Color(0xFFE8E8E8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail du paiement"),
          centerTitle: true,
          backgroundColor: Color(0xFF146C94),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 18.0, bottom: 4.0),
          child: Text(
            "DETAILS DU PAIEMENT",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 18.0, bottom: 20.0),
          child: DataTable(
            columnSpacing: 155.0,
            dataRowHeight: 20,
            headingRowHeight: 0,
            border: TableBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.zero,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                top: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
                right: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
                horizontalInside: BorderSide(color: Colors.black, width: 1)),
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  '',
                ),
              ),
              DataColumn(
                label: Text(
                  '',
                ),
              ),
            ],
            rows: List.generate(getdataDetails.length, (index) {
              final item = getdataDetails[index];
              return DataRow(
                cells: [
                  DataCell(Text(
                    item['fRow'],
                    style:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(
                    item['sRow'],
                    style: TextStyle(fontSize: 10, color: Color(0xFF6E6E6E)),
                  )),
                ],
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 18.0, bottom: 4.0),
          child: Text(
            "RECAPITULATIF DES INFORMATIONS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 18.0),
          child: DataTable(
            dataRowHeight: 20,
            headingRowHeight: 20,
            headingRowColor: MaterialStateProperty.resolveWith(getColor),
            border: TableBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.zero,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                top: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
                right: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
                horizontalInside: BorderSide(color: Colors.black, width: 1)),
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Reference',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              DataColumn(
                label: Text(
                  'Prix TTC',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
            rows: List.generate(getDataRecap().length, (index) {
              final item = getDataRecap()[index];
              return DataRow(
                color: MaterialStateProperty.resolveWith(getColor),
                cells: [
                  DataCell(Text(
                    item['Reference'],
                    style: TextStyle(fontSize: 10),
                  )),
                  DataCell(Text(
                    item['Description'],
                    style: TextStyle(fontSize: 10),
                  )),
                  DataCell(Text(
                    item['Prix TTC'],
                    style: TextStyle(fontSize: 10),
                  )),
                ],
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0, left: 100),
          child: SizedBox(
            height: 45,
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Color(0xFF146C94),
              ),
              onPressed: () async {
                try {
                  final clientId = int.parse(
                      widget.id); // Assuming widget.id is the client ID
                  final destinationSMSNumber = widget.tel; // Replace with the actual destination number

                  final url = Uri.parse(
                      'https://jabak-lah-backend.onrender.com/api/sendfakesms'); // Replace with your API URL

                  final body = jsonEncode({
                    'clientId': clientId,
                    'destinationSMSNumber': destinationSMSNumber,
                  });

                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: body,
                  );

                  if (response.statusCode == 200) {
                    // SMS sent successfully
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SMS(
                            id: widget.id,
                            selectedImpayes: widget.selectedImpayes,
                            tel: widget.tel,
                          ),
                        ),
                    );
                  } else {
                    // Failed to send SMS
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('SMS Failed'),
                          content: Text('Failed to send the SMS.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  // Handle exception
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to send the SMS. $e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },

              //Navigator.of(context).pushNamed('SMS');
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              "Confirmer et signer",
              style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 17,
              color: Colors.white,
            ),
          ),
          ],
        )
      //foregroundColor: Colors.black,
      //backgroundColor: Colors.lightGreenAccent,
    ),
    ),
    ),
    ],
    ),
    );
  }
}
