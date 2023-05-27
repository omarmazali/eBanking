import 'package:flutter/material.dart';

class SMS extends StatefulWidget {
  const SMS({Key? key}) : super(key: key);

  @override
  State<SMS> createState() => _SMSState();
}

class _SMSState extends State<SMS> {

  final _formKey = GlobalKey<FormState>();
  final _numController = TextEditingController();
  final _emailController = TextEditingController();


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
                  bottomRight: Radius.circular(25)
              )
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _numController,
                        cursorColor: Color(0xFF146C94),
                        decoration: InputDecoration(
                          labelText: "Code reçu par SMS",
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade600)),
                          labelStyle: TextStyle(
                              color: Colors.grey.shade600
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF146C94))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10, left: 130),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Renvoyer le code",
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          onPressed: () {
                            Navigator.of(context).pushNamed("");
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
                          )
                        //foregroundColor: Colors.black,
                        //backgroundColor: Colors.lightGreenAccent,
                      ),
                    ),
                  ],
                )),
          ),
        )
    );
  }
}
