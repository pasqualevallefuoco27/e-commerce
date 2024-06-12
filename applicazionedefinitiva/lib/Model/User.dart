import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Cart.dart';

class User {
  final String uid;
  String name;
  String surname;
  Timestamp dob;
  Cart cart;
  bool isAmministrator;

  User({
    required this.uid,
    required this.name,
    required this.surname,
    required this.dob,
    required this.cart,
    this.isAmministrator = false
  });

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'name': name,
      'surname': surname,
      'dob':dob,
      'cart': cart.toMap(),
      'isAmministrator': isAmministrator
    };
  }
  factory User.fromMap(Map<String, dynamic> map){
    return User(
      uid: map['uid'],
      name: map['name'],
      surname: map['surname'],
      dob: map['dob'],
      cart: Cart.fromMap(map['cart']),
        isAmministrator: map['isAmministrator']
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

}