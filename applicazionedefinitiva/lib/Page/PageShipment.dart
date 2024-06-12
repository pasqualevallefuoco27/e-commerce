import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Model/Shipment.dart';
import 'package:applicazionedefinitiva/Service/ServiceAuth.dart';
import 'package:applicazionedefinitiva/Service/ServiceShipment.dart';
import 'package:applicazionedefinitiva/Widget/ShipmentCard.dart';
import '../Model/Item.dart';

class PageShipment extends StatefulWidget {
  const PageShipment({super.key});

  @override
  State<PageShipment> createState() => _PageShipmentState();
}

class _PageShipmentState extends State<PageShipment> {
  ServiceShipment serviceShipment= ServiceShipment();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spedizioni"),
        actions: [
          IconButton(
              onPressed: (){
                ServiceAuth().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
          future: serviceShipment.getAll(ServiceAuth().currentUser!.uid),
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<Shipment> shipments = snapshot.requireData;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: shipments.length,
                  itemBuilder: (context, index) {

                    //Costruzione Pagina
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.primary
                          ),
                          borderRadius: BorderRadius.circular(3.0)
                        ) ,
                          child: Column(
                              children: ShipmentCard(context, shipments[index])
                          )
                      ),
                    );


                  }
                  );
            }
            return const Center(child: Text('Nessuna Spedizione'),);
          }
      ),
    );
  }
}
