

import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';
class DrawerCard extends StatefulWidget {
  late String title;

  DrawerCard({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _DrawerCardState();

}

class _DrawerCardState extends State<DrawerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: 
          SizedBox(
            width: 280,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
              colors: [
            Colors.amber.shade50,
            Colors.orange.shade50,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: customTopPadding(0.02)),
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                    ),
                ],
              )
              ),
          ),
    );
  }
}