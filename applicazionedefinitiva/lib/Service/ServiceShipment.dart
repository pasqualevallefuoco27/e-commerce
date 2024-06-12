import '../Model/Cart.dart';
import '../Model/Shipment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ServiceShipment{
  final collectionRef = FirebaseFirestore.instance.collection('Shipments').withConverter(
      fromFirestore: (snapshot, _) => Shipment.fromMap(snapshot.data()!),
      toFirestore: (Shipment shipment, _) => shipment.toMap()
  );

  void set(Shipment shipment){
    collectionRef.doc(shipment.uid).set(shipment);
  }
  Future<List<Shipment>> getAll(String uidUser) async{
    List<Shipment> shipments = [];
    DateTime now = DateTime.now();
    QuerySnapshot<Shipment> query = await collectionRef.where('uidUser' ,isEqualTo: uidUser)
        .where('whenBought', isGreaterThan: now.subtract(const Duration(days: 2))).get();
    query.docs.forEach((element) {shipments.add(element.data());});
    return shipments;
  }
}