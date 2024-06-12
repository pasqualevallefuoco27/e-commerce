import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Cart.dart';

class Shipment {
  final String uid;
  final String uidUser;
  final Cart cart;
  final Timestamp whenBought;

  Shipment({
    required this.uid,
    required this.uidUser,
    required this.cart,
    required this.whenBought,
  });

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'uidUser': uidUser,
      'cart': cart.toMap(),
      'whenBought' : whenBought
    };
  }
  factory Shipment.fromMap(Map<String, dynamic> map){
    return Shipment(
      uid: map['uid'],
      uidUser: map['uidUser'],
      cart: Cart.fromMap(map['cart']),
      whenBought: map['whenBought'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Shipment.fromJson(String source) => Shipment.fromMap(json.decode(source));

}