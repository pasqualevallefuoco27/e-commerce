import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Model/Shipment.dart';
import 'package:applicazionedefinitiva/Service/ServiceAuth.dart';
import 'package:applicazionedefinitiva/Service/ServiceShipment.dart';
import 'package:applicazionedefinitiva/Service/ServiceUser.dart';

import '../Model/Item.dart';
import '../Model/User.dart';

class PageCart extends StatefulWidget {
  const PageCart({super.key});

  @override
  State<PageCart> createState() => _PageCartState();
}

class _PageCartState extends State<PageCart> {
  ServiceUser serviceUser = ServiceUser();
  late User user;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Carrello"),
          actions: [
            IconButton(
                onPressed: (){
                  ServiceAuth().signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: FutureBuilder(
          future: serviceUser.get(ServiceAuth().currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<User> doc = snapshot.requireData;
              user = doc.data()!;
              if(user.cart.items.isNotEmpty){
                return Column(
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: user.cart.items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: SizedBox(
                                width: 100,
                                height: 100,
                                child:user.cart.items[index]['item'].image!.isEmpty ? Image.asset('asset/empty-image.png', fit: BoxFit.cover) :Image.network(user.cart.items[index]['item'].image![0]),
                              ),
                              title: Text("${user.cart.items[index]['item'].name}",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantità: ${user.cart.items[index]['numberItems']}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Prezzo:${user.cart.items[index]['item'].price*user.cart.items[index]['numberItems']}€',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  serviceUser.deleateItemFromCart(user, user.cart.items[index]['item']);
                                  setState(() {});
                                },
                                icon:
                                const Icon(Icons.remove_shopping_cart_outlined),
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child:
                            Text(
                              "Prezzo Totale: ${user.cart.totalPrice}€",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor
                              ),
                            )
                        ),
                      ),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(),
                            fixedSize: Size.fromWidth(screenWidth),
                          ),
                          onPressed: () {
                            ServiceShipment serviceShipment= ServiceShipment();
                            serviceShipment.set(
                                Shipment(
                                    uid: serviceShipment.collectionRef.doc().id,
                                    uidUser: user.uid,
                                    cart: user.cart ,
                                    whenBought: Timestamp.now()
                                )
                            );
                            serviceUser.resetCart(user.uid);
                            setState(() {

                            });
                          },

                          child: const Text("Effettua l'acquisto"))


                    ],
                  );
              }
              return const Center(child: Text('Nessun oggetto'));
            }
            return const Center(child: Text('Errore'));
          },
        ),
    );
  }
}
