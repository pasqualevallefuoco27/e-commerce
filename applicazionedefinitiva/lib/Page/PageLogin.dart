import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Service/ServiceAuth.dart';
import 'PageRegistration.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email= TextEditingController();
  final TextEditingController _password= TextEditingController();
  static final RegExp passReg = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView(
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 85.0, horizontal: 8.0),
                  child: Text("Login",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w300,
                      )
                  )
              ),
              Form(
                  key:_formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          controller: _email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("email"),
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
                            label: Text("password"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async{
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate() == true){
                                try{
                                  await ServiceAuth().signInWithEmailAndPassword(email: _email.text, password: _password.text);
                                }
                                on FirebaseAuthException {}
                              }
                              },
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                fixedSize: Size.fromWidth(screenWidth)
                            ),
                            child: const Text("Effettua Login")
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const PageRegistration(),
                                ),
                              );
                            });
                          },
                          child: const Text("Registrati")
                      )
                    ],
                  )
              ),
            ]
        )
    );
  }
}
