import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';
import 'package:getjournaled/journals/journal_card.dart';

class Drawer extends StatefulWidget {
  const Drawer({super.key});

  @override
  State<Drawer> createState() => _Drawer();
}

class _Drawer extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: customTopPadding(0.025)),
              const Text('Journals',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700 ,
                color: Colors.white
              ),),
              Padding(padding: customTopPadding(0.1)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DrawerCard(title: 'Title'),
                    ),
                    DrawerCard(title: 'Title2'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Container(
      decoration:  BoxDecoration(
          color: Colors.black,
          ),
      child:  Drawer(),
    ));
  }
}
