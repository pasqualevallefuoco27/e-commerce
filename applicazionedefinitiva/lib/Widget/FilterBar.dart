import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key, });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String type= "All";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
              onPressed: (){
                setState(() {
                  type='All';
                });
              },
              child: const Text('Tutto'),


            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    type='Frutta';
                  });
                },
                child: const Text('Frutta')
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    type='Verdura';
                  });
                },
                child: Text('Verdura')
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    type='Piante';
                  });
                },
                child: Text('Piante')
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    type='Fiori';
                  });
                },
                child: Text('Fiori')
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: (){
                  setState(() {
                    type='Animali';
                  });
                },
                child: Text('Animali')
            ),
          ),
        ],
      ),
    );
  }
}
