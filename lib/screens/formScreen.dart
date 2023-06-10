import 'package:flutter/material.dart';

import '../models/form.dart';
import '../models/credential.dart';
import '../services/formSoap.dart';
import '../services/impayeSoap.dart';
import 'impayeScreen.dart';

class FormScreen extends StatefulWidget {
  final String id;
  final String tel;
  final String creanceID;
  final String creancierName;
  final String creanceName;
  final String fname;
  final String lname;

  FormScreen({required this.id, required this.tel, required this.creanceID, required this.creancierName, required this.creanceName, required this.fname, required this.lname});

  @override
  State<FormScreen> createState() => _FormFormScreenState();
}

class _FormFormScreenState extends State<FormScreen> {
  final FormSoap formSoap = FormSoap();
  final ImpayeSoap impayeSoap = ImpayeSoap();
  List<Forms> forms = [];
  Map<String, String> champValues = {};

  Future<void> fetchFormsByCreanceID(String creanceID) async {
    final fetchedFormsByCreanceID =
        await formSoap.fetchFormsByCreanceID(creanceID);
    setState(() {
      forms = fetchedFormsByCreanceID;
      champValues = {};
      for (var form in forms) {
        for (var champ in form.champs) {
          champValues[champ.id] = champ.value;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFormsByCreanceID(widget.creanceID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remplissez vos informations"),
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
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: forms
                    .map(
                      (form) => ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: form.champs
                              .map(
                                (champ) => TextFormField(
                                  cursorColor: Color(0xFF146C94),
                                  decoration: InputDecoration(
                                    labelText: champ.label,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    labelStyle:
                                        TextStyle(color: Colors.grey.shade600),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF146C94)),
                                    ),
                                  ),
                                  initialValue: champValues[champ.id],
                                  onChanged: (value) {
                                    setState(() {
                                      champValues[champ.id] = value;
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 350,
              ),
              SizedBox(
                height: 45,
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Color(0xFF146C94),
                  ),
                  onPressed: () async {
                    bool allFieldsFilled = true;
                    for (var form in forms) {
                      for (var champ in form.champs) {
                        if (champValues[champ.id] == null ||
                            champValues[champ.id]!.isEmpty) {
                          allFieldsFilled = false;
                          break;
                        }
                      }
                    }
                    if (allFieldsFilled) {
                      List<Credential> credentials = forms.expand((form) {
                        return form.champs.map((champ) {
                          return Credential(
                              name: champ.name,
                              value: champValues[champ.id] ?? '');
                        });
                      }).toList();

                      final fetchedImpayes =
                          await impayeSoap.fetchImpayesByCreanceID(
                              widget.creanceID, credentials);

                      if (fetchedImpayes.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Pas de factures disponibles"),
                            content: Text("Aucune facture impayée n'est disponible."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImpayeScreen(
                              id: widget.id,
                              tel: widget.tel,
                              impayes: fetchedImpayes,
                              creancierName: widget.creancierName,
                              creanceName: widget.creanceName,
                              fname: widget.fname,
                              lname: widget.lname,
                            ),
                          ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Missing Fields"),
                          content: Text(
                            "Please fill in all fields before validating.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Valider",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
