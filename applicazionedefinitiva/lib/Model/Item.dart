import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Item{
  final String uid;
  String name;
  String description;
  double price;
  int bought;
  List<String>? image = [];
  String type;
  Timestamp whenInsert;

  Item({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.bought,
    this.image,
    required this.type,
    required this.whenInsert
  });

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'name': name,
      'description': description,
      'price': price,
      'bought': bought,
      'image': image,
      'type': type,
      'whenInsert': whenInsert
    };
  }
  factory Item.fromMap(Map<String, dynamic> map){
    var image = map['image']; // array is now List<dynamic>
    List<String> strings = List<String>.from(image);
    return Item(
        uid: map['uid'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        bought: map['bought'],
        image: strings,
        type: map['type'],
        whenInsert: map['whenInsert']
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));



}