import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/Item.dart';

class ServiceItem{
  final collectionRef = FirebaseFirestore.instance.collection('Items').withConverter(
      fromFirestore: (snapshot, _) => Item.fromMap(snapshot.data()!),
      toFirestore: (Item item, _) => item.toMap()
  );
  void set(Item item){
    collectionRef.doc(item.uid).set(item);
  }


  Future<List<Item>> getItems(String type) async{
    List<Item> list = [];
    QuerySnapshot<Item> query;


    switch (type){
      case "All":{
        print(type);
        query= await collectionRef.where('type', isNotEqualTo: "").get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;
      }
      case "Last":{
        print(type);
        query = await collectionRef.orderBy('whenInsert', descending: true).get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;

      }

      case "MostBought": {
        query = await collectionRef.orderBy('bought', descending: true).get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;

      }

      case "LastRandom": {
        List<String> types= ["Frutta", "Verdura", "Piante", "Animali"];
        var intValue = Random().nextInt(5);
        query = await collectionRef.where('type', isEqualTo: types[intValue]).orderBy('whenInsert', descending: true).get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;

      }

      case "MostBoughtRandom": {
        List<String> types= ["Frutta", "Verdura", "Piante", "Animali"];
        var intValue = Random().nextInt(5);
        query = await collectionRef.where('type', isEqualTo: types[intValue]).orderBy('bought', descending: true).get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;

      }

      default: {
        print(type);
        query= await collectionRef.where('type', isEqualTo: type).get();
        query.docs.forEach((element) {list.add(element.data());});
        return list;
      }

    }
  }

  void update(String uid, Map<String,dynamic> map){
    collectionRef.doc(uid).update(map);
  }


  void deleate(String uid) async{
    collectionRef.doc(uid).delete();

  }

}