import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Service/ServiceItem.dart';

import '../Model/Item.dart';
import '../Page/PageItem.dart';

Widget ItemCard({
  required BuildContext context,
  required Item item,
  required double height,
  required bool isAmministrator})
{
  ServiceItem serviceItem= ServiceItem();
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
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.primary
              ),
              borderRadius: BorderRadius.circular(3.0)
          ) ,
          child: Column(children: [
            SizedBox(
                height: height,
                child: item.image!.isEmpty ? Image.asset('asset/empty-image.png', fit: BoxFit.cover) : Image.network(item.image![0], fit: BoxFit.cover)
            ),
            ListTile(
              title: Text(item.name),
              subtitle: Text(
                "Prezzo:${item.price.toString()}",
                style: TextStyle(
                    fontSize: 20,
                  color: Theme.of(context).primaryColor
                ),
              ),
              trailing: isAmministrator==true
                  ? IconButton(
                  onPressed: (){
                    serviceItem.deleate(item.uid);
                    }, icon: const Icon(Icons.delete))
                  : Container()
            )
          ]
          )
      ),
    ),
  );
}