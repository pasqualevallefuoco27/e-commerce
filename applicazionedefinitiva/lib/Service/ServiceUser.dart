import 'package:applicazionedefinitiva/Service/ServiceItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/Cart.dart';
import '../Model/Item.dart';
import '../Model/User.dart';

class ServiceUser{
  final collectionRef = FirebaseFirestore.instance.collection('Users').withConverter(
      fromFirestore: (snapshot, _) => User.fromMap(snapshot.data()!),
      toFirestore: (User user, _) => user.toMap()
  );

  void set(User user){
    collectionRef.doc(user.uid).set(user);
  }

  Future<DocumentSnapshot<User>> get(String uid) async {
    return await collectionRef.doc(uid).get();
  }

  void update(User user){
    collectionRef.doc(user.uid).update(user.toMap());
  }


  void resetCart(String uid){
    Cart cart = (Cart(items:[], totalPrice: 0));
    collectionRef.doc(uid).update({'cart' : cart.toMap()});
  }

  void addItemToCart(User user, Item item, int numberOfItems){
    ServiceItem serviceItem= ServiceItem();
    item.bought += numberOfItems;
    serviceItem.update(item.uid, {'bought': item.bought});
    user.cart.items.add({'item':item, 'numberItems': numberOfItems});
    user.cart.totalPrice += item.price*numberOfItems;
    update(user);
  }

  void deleateItemFromCart(User user, Item item){
     int numberItem = 1;
     user.cart.items.forEach((element) {
       if(item.uid == element['item'].uid){
         numberItem= element['numberItems'];
       }
     });
     user.cart.totalPrice -= item.price*numberItem;
     user.cart.items.removeWhere((element) =>
     element['item'].uid == item.uid);
     set(user);
  }



}