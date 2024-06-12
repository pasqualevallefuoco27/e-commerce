import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Service/ServiceAuth.dart';
import 'package:applicazionedefinitiva/Service/ServiceItem.dart';
import 'package:applicazionedefinitiva/Widget/ItemMiniCard.dart';

import '../Model/Item.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}


class _PageHomeState extends State<PageHome> {
  ServiceItem serviceItem = ServiceItem();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce"),
        actions: [
          IconButton(
              onPressed: (){
                ServiceAuth().signOut();
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: ListView(
        children: [

            const Padding(
              padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
              child: SizedBox(
                height: 35,
                child: Text('Ultime aggiunte',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400
                )
                ),
              ),
            ),
            //Definizione altezza riga
                SizedBox(
                  height: 150,
                  child: FutureBuilder(
                      future: serviceItem.getItems('Last'),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<Item> list = snapshot.requireData;
                          print(list[0]);
                          return ListView.builder(
                              shrinkWrap: true,
                            itemCount: list.length<=5 ? list.length: 5 ,
                            scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return ItemMiniCard(context, list[index]);
                            }
                          );
                        }
                        return Container(
                        );
                      }

                      ),
                ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
              child: SizedBox(
                height: 35,
                child: Text('I più acquistati',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
            ),
            //Definizione altezza riga
            SizedBox(
              height: 150,
              child: FutureBuilder(
                  future: serviceItem.getItems('MostBought'),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      List<Item> list = snapshot.requireData;
                      print(list[0]);
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length<=5? list.length : 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            // Card
                            return ItemMiniCard(context, list[index]);
                          }
                      );
                    }
                    return Container(
                    );
                  }

              ),
            ),
            FutureBuilder(
                future: serviceItem.getItems('LastRandom'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Item> list = snapshot.requireData;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
                          child: SizedBox(
                            height: 35,
                            child: Text('Ultime aggiunte ${list[0].type}',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 150,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length >= 5 || list.isEmpty? list.length : 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  // Card
                                  return ItemMiniCard(context, list[index]);
                                }
                            )
                        )
                      ],
                    );
                  }
                  return Container();
                }
                ),
          FutureBuilder(
              future: serviceItem.getItems('MostBoughtRandom'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Item> list = snapshot.requireData;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
                        child: SizedBox(
                          height: 35,
                          child: Text('Più acquistati in ${list[0].type}',
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 150,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length >= 5 || list.isEmpty? list.length : 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // Card
                                return ItemMiniCard(context, list[index]);
                              }
                          )
                      )
                    ],
                  );
                }
                return Container();
              }
          ),


              ],
        ),

    );

  }
}
