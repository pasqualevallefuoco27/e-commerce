import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Page/PageSwitch.dart';
import 'package:applicazionedefinitiva/Service/ServiceItem.dart';
import 'package:applicazionedefinitiva/Service/ServiceStorage.dart';

import '../Model/Item.dart';

class PageAddItem extends StatefulWidget {
  const PageAddItem({super.key});

  @override
  State<PageAddItem> createState() => _PageAddItemState();
}

class _PageAddItemState extends State<PageAddItem> {
  //GlobalKey Form
  final _formKey = GlobalKey<FormState>();
  //Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price= TextEditingController();
  final TextEditingController _description = TextEditingController();
  //Validate variables
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  static final RegExp numberRegExp = RegExp(r'\d');
  //Services
  ServiceItem serviceItem = ServiceItem();
  ServiceStorage serviceStorage= ServiceStorage();
  //Variables
  List<String> list = <String>['Frutta', 'Verdura', 'Piante', 'Animali'];
  String type= "";
  List<String?> immages= [];
  List<File> files= [];
  Icon icon= const Icon(Icons.check_box_outline_blank);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title:const Text('Crea Oggetto')),
        body:Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Nome')
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Campo obbligatorio";
                    }
                    if(nameRegExp.hasMatch(value) == false){
                      return "Inserire solo lettere";
                    }
                    },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _price,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Prezzo')
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Campo obbligatorio";
                    }
                    if(numberRegExp.hasMatch(value) == false){
                      return "Inserire solo numeri";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  validator: (value){
                    if(value!.isEmpty) {
                      return "Campo obbligatorio";
                    }
                  },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Tipo')
                    ),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },


                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Descrizione')
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Campo obbligatorio";
                    }
                  },
                ),
              ),
              ListTile(
                leading: icon,
                title: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () async{
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                      );

                      if (result != null) {
                        immages = result.paths;
                        files = result.paths.map((path) => File(path!)).toList();
                        setState(() {
                          icon= const Icon(Icons.check_box_outlined);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Scelte ${files.length} immagini')
                            )
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nessuna immagine scelta')
                            )
                        );

                      }

                    },
                    child: const Text('Carica Immagini')
                ) ,
              ),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    fixedSize: Size.fromWidth(screenWidth),
                  ),
                  onPressed: () async {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate() == true) {

                      //Caricamento Immaggini
                      List<String> urlImages = [];
                      if (files.isNotEmpty) {
                        urlImages= await serviceStorage.uploadMultipleFiles(immages, files);
                      }

                      //Creazione Item
                      serviceItem.set(
                          Item(
                              uid: serviceItem.collectionRef
                                  .doc()
                                  .id,
                              name: _name.text,
                              description: _description.text,
                              price: double.parse(_price.text),
                              image: urlImages,
                              type: type,
                            whenInsert: Timestamp.now(),
                              bought: 0
                          )
                      );

                      //Indirizzamento allo switch
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Item aggiunto')
                          )
                      );

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PageSwitch(),
                          )
                      );
                    }
                    },
                  child: const Text('Crea nuovo oggetto')
              )


            ],
          ),

        )
    );
  }
}
