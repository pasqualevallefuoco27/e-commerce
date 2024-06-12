import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Item.dart';
import '../Page/PageItem.dart';

Widget ItemMiniCard(BuildContext context, Item item){

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PageItem(item: item),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
          border: Border.all(
              width: 1.0,
              color: Theme.of(context).colorScheme.primary
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 75,
                child: item.image!.isEmpty ?
                Image.asset('asset/empty-image.png', fit: BoxFit.cover) :
                Image.network(item.image![0], fit: BoxFit.cover)),
            SizedBox(
              height: 40,
              child: Text(
                item.name,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).primaryColor
                ),
              ),
            ),
            SizedBox(
              height: 15,
              child: Text(
                'Prezzo: ${item.price.toString()}€',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}