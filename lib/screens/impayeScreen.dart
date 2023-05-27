import 'package:flutter/material.dart';
import '../models/impaye.dart';
import 'detailScreen.dart';

class ImpayeScreen extends StatefulWidget {
  final List<Impaye> impayes;
  final String creancierName;
  final String creanceName;

  ImpayeScreen({required this.impayes, required this.creancierName, required this.creanceName});

  @override
  _ImpayeScreenState createState() => _ImpayeScreenState();
}

class _ImpayeScreenState extends State<ImpayeScreen> {
  List<Impaye> selectedImpayes = [];

  @override
  Widget build(BuildContext context) {
    print('Impayes: ${widget.impayes}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Selectionner vos factures"),
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.impayes.length,
                itemBuilder: (context, index) {
                  final impaye = widget.impayes[index];
                  final isSelected = selectedImpayes.contains(impaye);
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.only(right: 10.0, left: 5.0),
                      dense: true,
                      title: Text(
                        impaye.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      secondary: Text("01/01/2023"),
                      subtitle: Text("Price: ${impaye.price}"),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedImpayes.add(impaye);
                          } else {
                            selectedImpayes.remove(impaye);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF146C94),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detail(
                creancierName: widget.creanceName,
                creanceName: widget.creancierName,
                debiteurName: "Mohamed Hamdani",
                dateCreance: DateTime.now(),
                selectedImpayes: selectedImpayes,
              ),
            ),
          );
          print("Selected Impayes: $selectedImpayes");
        },
        child: Icon(Icons.check,),
      ),
    );
  }
}
