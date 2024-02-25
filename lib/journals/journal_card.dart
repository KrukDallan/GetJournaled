

import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';
class DrawerCard extends StatefulWidget {
  late int id;
  late String title;
  late String body;
  late DateTime dateOfCreation;
  late Color cardColor;
  late int dayRating;
  late String highlight;
  late String lowlight;
  late String noteWorthy;

  DrawerCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.dateOfCreation,
    required this.cardColor,
    required this.dayRating,
    required this.highlight,
    required this.lowlight,
    required this.noteWorthy,
  });

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
            width: 350,
            height: 340,
            child: Container(
              decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: widget.cardColor,
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