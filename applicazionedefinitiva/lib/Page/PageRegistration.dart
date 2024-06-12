import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Service/ServiceUser.dart';
import '../Model/Cart.dart';
import '../Model/User.dart';
import '../Service/ServiceAuth.dart';
import '../Service/ServiceStorage.dart';
import '../main.dart';

class PageRegistration extends StatefulWidget {
  const PageRegistration({super.key});

  @override
  State<PageRegistration> createState() => _PageRegistrationState();
}

class _PageRegistrationState extends State<PageRegistration> {
  //Controller form
  final TextEditingController _email= TextEditingController();
  final TextEditingController _password= TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  //GlobalKey Form
  final _formKey = GlobalKey<FormState>();
  //Validate variables
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  //Un carattere maiuscolo, uno minuscolo, un numero e parola lunga almeno 8 caratteri
  static final RegExp passReg = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  //Servizi
  ServiceUser serviceUser= ServiceUser();
  ServiceStorage serviceStorage= ServiceStorage();
  //Variabili
  File? file;
  String immagineProfilo = 'Asset/png-clipart-webcam-empty-square-angle-white.png';
  Timestamp dob = Timestamp.now();
  Icon icon= const Icon(Icons.check_box_outline_blank);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body:ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Text(
                  "Registrazione",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  )
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Campo obbligatorio";
                        }
                        if(nameRegExp.hasMatch(value) == false){
                          return "Inserire solo lettere";
                        }
                      },
                      keyboardType: TextInputType.name,
                      controller: _name,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Nome')
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Campo obbligatorio";
                        }
                        if(nameRegExp.hasMatch(value) == false){
                          return "Inserire solo lettere";
                        }
                      },
                      keyboardType: TextInputType.name,
                      controller: _surname,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Cognome')
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DateTimeFormField(
                        decoration: const InputDecoration(
                          labelText: 'Data di nascita',
                          border: OutlineInputBorder(),
                        ),
                        firstDate: DateTime(1920,1,1),
                        lastDate: DateTime.now(),
                        initialPickerDateTime: DateTime.now(),
                        mode: DateTimeFieldPickerMode.date,
                        onChanged: (DateTime? value) {
                          dob = value as Timestamp;
                        },
                        validator: (value){
                          if(value == null){
                            return "Campo obbligatorio";
                          }
                        },
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Campo obbligatorio";
                        }
                        if(EmailValidator.validate(value)==false){
                          return "Email non valida";
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Campo obbligatorio";
                        }
                        if(passReg.hasMatch(value) == false){
                          return "Password non valida";
                        }
                      },
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Password"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          fixedSize: Size.fromWidth(screenWidth),
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate() == true) {
                            // Registrazione su Authentication
                            await ServiceAuth().createUserWithEmailAndPassword(
                                email: _email.text, password: _password.text);


                            //Creazione istanza utente
                            serviceUser.set(
                                User(
                                  uid: ServiceAuth().currentUser!.uid,
                                  name: _name.text,
                                  surname: _surname.text,
                                  dob: dob,
                                  cart: Cart(items: [], totalPrice: 0),
                                )
                            );


                            //Indirizzamento al main
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MainApp(),
                              ),
                            );
                          }
                        },
                        child: const Text('Effettua La Registrazione')
                    ),
                  ),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: const Text(
                          "Hai gia un account? Effettua il login",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          )
                      )
                  ),


                ],
              ),

            ),
          ],
        )
    );
  }
}
