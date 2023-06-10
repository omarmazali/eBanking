import 'package:flutter/material.dart';
import '../models/impaye.dart';
import '../services/soldeSoap.dart';

class SMS extends StatefulWidget {
  final String id;
  final List<Impaye> selectedImpayes;
  final String tel;

  SMS({
    required this.id,
    required this.selectedImpayes,
    required this.tel,
  });

  @override
  State<SMS> createState() => _SMSState();
}

class _SMSState extends State<SMS> {
  final _formKey = GlobalKey<FormState>();
  final _numController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validation"),
        centerTitle: true,
        backgroundColor: Color(0xFF146C94),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _numController,
                      cursorColor: Color(0xFF146C94),
                      decoration: InputDecoration(
                        labelText: "Code reçu par SMS",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF146C94)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field should not be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 350),
                  SizedBox(
                    height: 45,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Color(0xFF146C94),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final String code = _numController.text;
                          List<String> impayesIDs = widget.selectedImpayes
                              .map((impaye) => impaye.id)
                              .toList();
                          final String paymentStatus = await SoldeService()
                              .confirmerPaiement(
                            impayesIDs,
                            widget.id,
                            code,
                          );
                          if (paymentStatus == "Paiement effectué") {
                            Navigator.of(context).pushNamed('/Home', arguments: widget.tel);
                            } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Payment Failed'),
                                  content: Text("Une erreur est survenue, verifier votre code SMS s'il est correcte"),
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
        ),
      ),
    );
  }
}
