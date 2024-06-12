import 'package:flutter/material.dart';

import '../Model/Item.dart';
import '../Page/PageItem.dart';
import '../Service/ServiceItem.dart';

class PageItemCard extends StatefulWidget {
  final Item item;
  final bool isAmministrator;
  const PageItemCard({
    super.key,
    required  this.item,
    required this.isAmministrator
  });


  @override
  State<PageItemCard> createState() => _PageItemCardState();
}

class _PageItemCardState extends State<PageItemCard> {
  ServiceItem serviceItem= ServiceItem();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PageItem(item: widget.item),
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
                  child: widget.item.image!.isEmpty ? Image.asset('asset/empty-image.png', fit: BoxFit.cover) : Image.network(widget.item.image![0], fit: BoxFit.cover)
              ),
              ListTile(
                  title: Text(widget.item.name),
                  subtitle: Text(
                    "Prezzo:${widget.item.price.toString()}",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                  trailing: widget.isAmministrator==true
                      ? IconButton(
                      onPressed: (){
                        serviceItem.deleate(widget.item.uid);
                        setState(() {

                        });
                      }, icon: const Icon(Icons.delete))
                      : Container()
              )
            ]
            )
        ),
      ),
    );
  }
}
