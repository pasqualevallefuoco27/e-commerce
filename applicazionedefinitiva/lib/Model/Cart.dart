import 'dart:convert';

import 'Item.dart';

class Cart{
  List<Map<String, dynamic>> items;
  double totalPrice;

  Cart({
    required this.items,
    required this.totalPrice
  }
  );

  Map<String, dynamic> toMap(){
    List<Map<String,dynamic>> mapItems=[];
    items.forEach((element) {
      mapItems.add({
        'item': (element['item'].toMap()),
        'numberItems': element['numberItems']
      });
    });
    return{
      'items': mapItems,
      'totalPrice': totalPrice,
    };
  }
  factory Cart.fromMap(Map<String, dynamic> map){
    List<Map<String, dynamic>> items= [];
    for(Map<String,dynamic> mapItem in map['items']){
      items.add({'item':Item.fromMap(mapItem['item']), 'numberItems': mapItem['numberItems']});
    }
    return Cart(
        items: items,
        totalPrice: map['totalPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));
}