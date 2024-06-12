import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Model/Shipment.dart';

import '../Model/Item.dart';

List<Widget> ShipmentCard (BuildContext context, Shipment shipment) {
  List<Widget> order = [];
  order.add(
      Container(
          color: Theme.of(context).primaryColor,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
          child: Text(
            'Ordine: ${shipment.uid}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          )
      )
  );
  order.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Data di conegna: ${shipment.whenBought.toDate().add(const Duration(days: 2))}',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
        ),
      )
  )
  );
  for(Map<String,dynamic> items in shipment.cart.items){
    order.add(ListTile(
      leading: SizedBox(
        width: 100,
        height: 100,
        child:items['item'].image!.isEmpty ? Image.asset('asset/empty-image.png', fit: BoxFit.cover) :Image.network(items['item'].image![0]),
      ),
      title: Text(items['item'].name,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantità: ${items['numberItems']}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
            ),
          ),
          Text(
            'Prezzo:${items['item'].price*items['numberItems']}€',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ));
  }
  order.add(Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
        'Prezzo Totale: ${shipment.cart.totalPrice}€',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
      ),
    )
  )
  );


  return order;

}