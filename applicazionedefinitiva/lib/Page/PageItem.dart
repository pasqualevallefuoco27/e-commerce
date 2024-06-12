import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Service/ServiceAuth.dart';
import 'package:applicazionedefinitiva/Service/ServiceItem.dart';
import 'package:applicazionedefinitiva/Service/ServiceUser.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../Model/Item.dart';
import '../Model/User.dart';

class PageItem extends StatefulWidget {
  final Item item;
  const PageItem({super.key, required this.item});

  @override
  State<PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  String buttonText = "Aggiungi al carrello";
  ServiceUser serviceUser = ServiceUser();
  ServiceItem serviceItem = ServiceItem();
  List<int> list = <int>[1,2,3,4,5,6,7,8,9];
  int numberOfItems = 1;
  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
          appBar: AppBar(
            title: const Text("Acquista"),
          ),
          body: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 1)
                  ),
                  child: FlutterCarousel.builder(
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 16 / 9,
                        initialPage: 0,
                        slideIndicator: const CircularSlideIndicator(
                            indicatorRadius: 4, itemSpacing: 13
                        )
                    ),
                    itemCount: widget.item.image!.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return widget.item.image!.isEmpty ? Image.asset('asset/empty-image.png') : Image.network(widget.item.image![index]);
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical:12.0),
                    child: Text(widget.item.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                        )
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Prezzo:${(widget.item.price*numberOfItems).toString()}€",
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: DropdownButtonFormField<int>(
                      validator: (value){
                        if(value == null) {
                          return "Campo obbligatorio";
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Seleziona numero articoli',
                          border: OutlineInputBorder(),
                      ),
                      items: list.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('Quantità: $value'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          numberOfItems = value!;
                        });
                      },


                    ),
                  ),
                ),
                FutureBuilder(
                    future: serviceUser.get(ServiceAuth().currentUser!.uid),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        DocumentSnapshot<User> doc = snapshot.requireData;
                        User user = doc.data()!;
                        bool isInCart= false;
                        user.cart.items.forEach((element) {
                          if(widget.item.uid == element['item'].uid){
                            isInCart = true;
                          }
                        });
                        if(isInCart == true){
                          return ElevatedButton(
                              onPressed: (){
                                serviceUser.deleateItemFromCart(user, widget.item);
                                  setState(() {});
                                  },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size.fromWidth(screenWidth),
                                  textStyle: const TextStyle(fontSize: 17),
                                  shape: const RoundedRectangleBorder()
                              ),
                              child: const Text('Nel Carrello')
                              );
                        }

                    return ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if(_formKey.currentState!.validate() == true) {
                            serviceUser.addItemToCart(user, widget.item, numberOfItems);
                            setState(() {});
                          }
                          },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size.fromWidth(screenWidth),
                            textStyle: const TextStyle(fontSize: 17),
                            shape: const RoundedRectangleBorder()
                        ),
                        child: const Text("Aggiungi al carrello")
                    );
                      }
                      return const Center(child: Text('Errore'),);

                  }
                )
              ]
          ),

    );
  }
}
