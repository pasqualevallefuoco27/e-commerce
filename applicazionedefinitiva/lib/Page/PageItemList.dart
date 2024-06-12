import 'package:applicazionedefinitiva/Widget/FilterBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:applicazionedefinitiva/Page/PageAddItem.dart';
import 'package:applicazionedefinitiva/Service/ServiceAuth.dart';
import 'package:applicazionedefinitiva/Service/ServiceItem.dart';
import 'package:applicazionedefinitiva/Service/ServiceUser.dart';

import '../Model/Item.dart';
import '../Model/User.dart';
import 'PageItem.dart';

class PageItemList extends StatefulWidget {
  const PageItemList({super.key});

  @override
  State<PageItemList> createState() => _PageItemListState();
}

class _PageItemListState extends State<PageItemList> {
  ServiceItem serviceItem= ServiceItem();
  ServiceUser serviceUser= ServiceUser();
  String type = 'All';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: serviceUser.get(ServiceAuth().currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.hasData){
            DocumentSnapshot<User> doc = snapshot.requireData;
            User user = doc.data()!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Acquista'),
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                              onPressed: (){
                                setState(() {
                                  type='All';
                                });
                              },
                              child: const Text('Tutto'),


                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    type='Frutta';
                                  });
                                },
                                child: const Text('Frutta')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    type='Verdura';
                                  });
                                },
                                child: Text('Verdura')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    type='Piante';
                                  });
                                },
                                child: Text('Piante')
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                                onPressed: (){
                                  setState(() {
                                    type='Animali';
                                  });
                                },
                                child: Text('Animali')
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Item>>(
                        future: serviceItem.getItems(type),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                List<Item> items = snapshot.requireData;
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (context, index){
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PageItem(item:items[index]),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Theme.of(context).colorScheme.primary
                                                  ),
                                                  borderRadius: BorderRadius.circular(3.0)
                                              ) ,
                                              child: Column(children: [
                                                SizedBox(
                                                    height: 200,
                                                    child: items[index].image!.isEmpty ? Image.asset('asset/empty-image.png', fit: BoxFit.cover) : Image.network(items[index].image![0], fit: BoxFit.cover)
                                                ),
                                                ListTile(
                                                    title: Text(items[index].name),
                                                    subtitle: Text(
                                                      "Prezzo:${items[index].price.toString()}€",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Theme.of(context).primaryColor
                                                      ),
                                                    ),
                                                    trailing: user.isAmministrator==true
                                                        ? IconButton(
                                                        onPressed: (){
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext context) => AlertDialog(
                                                              title: const Text('Elimina'),
                                                              content: const Text("Sei sicuro di voler eliminare l'oggetto?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                  child: const Text('Indietro'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    serviceItem.deleate(items[index].uid);
                                                                    setState(() {
                                                                    });
                                                                    Navigator.pop(context, 'Ok');
                                                                  },
                                                                  child: const Text('Elimina'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                          }, icon: const Icon(Icons.delete))
                                                        : Container()
                                                )
                                              ]
                                              )
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }
                              else{
                                return const Center(
                                  child: Text('Nessun oggetto'),
                                );
                              }
                            }
                        ),
                  ],
                ),
              ),

              floatingActionButton: user.isAmministrator==true ? FloatingActionButton(
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PageAddItem(),
                      )
                  );
                },
                child: const Icon(Icons.add),
              ) : Container()
            );
          }
          return const Center(child: Text('Non sei loggato'),);

    }
    );

  }
}
