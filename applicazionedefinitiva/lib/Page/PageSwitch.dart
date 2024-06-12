import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Page/PageCart.dart';
import 'package:applicazionedefinitiva/Page/PageLogin.dart';
import 'package:applicazionedefinitiva/Page/PageShipment.dart';

import '../Service/ServiceAuth.dart';
import 'PageHome.dart';
import 'PageItemList.dart';

class PageSwitch extends StatefulWidget {
  const PageSwitch({super.key});

  @override
  State<PageSwitch> createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int paginaCorrente = 0;
  final schermate=[
    const PageHome(),
    const PageItemList(),
    const PageCart(),
    const PageShipment()
  ];


  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: ServiceAuth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Scaffold(
              bottomNavigationBar: NavigationBar(
                selectedIndex: paginaCorrente,
                onDestinationSelected: (int index) {
                  setState(() {paginaCorrente=index;});
                },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: "Home"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon:Icon(Icons.list_alt) ,
                      label: "See"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.shopping_cart_outlined),
                      selectedIcon:Icon(Icons.shopping_cart) ,
                      label: "Buy"
                  ),
                  NavigationDestination(
                      icon: Icon(Icons.local_shipping_outlined),
                      selectedIcon:Icon(Icons.local_shipping) ,
                      label: "Shipping"
                  ),
                ],
              ),
              body: schermate[paginaCorrente]
          );
        }
        return const PageLogin();

      }
    );
  }
}
