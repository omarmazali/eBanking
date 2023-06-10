import 'dart:core';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:untitled/services/operationService.dart';

class Operations extends StatefulWidget {
  final String username;

  Operations({required this.username});

  @override
  State<Operations> createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {
  List<OperationInfo> operations = [];
  List<OperationInfo> displayOperations = [];

  @override
  void initState() {
    super.initState();
    fetchOperations();
  }

  Future<void> fetchOperations() async {
    try {
      final List<OperationInfo> fetchedOperations =
          await OperationService.getOperationInfoByUsername(widget.username);
      setState(() {
        operations = fetchedOperations;
        displayOperations = List.from(operations);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateList(String value) {
    setState(() {
      displayOperations = operations
          .where((element) =>
              element.type!.toLowerCase().contains(value.toLowerCase()))
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
                child: displayOperations.length == 0
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
                        itemCount: displayOperations.length,
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
                            contentPadding:
                                EdgeInsets.only(left: 20.0, right: 8.0),
                            title: Text(
                              displayOperations[index].type,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              displayOperations[index].description,
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayOperations[index].type == "paiement"
                                        ? "-"
                                        : "+",
                                    style: TextStyle(
                                      color: displayOperations[index].type ==
                                              "paiement"
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    displayOperations[index].amount,
                                    style: TextStyle(
                                      color: displayOperations[index].type ==
                                              "paiement"
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                formatTimestamp(displayOperations[index].date),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
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

  String formatTimestamp(String date) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }
}
