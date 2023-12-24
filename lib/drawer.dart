import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';

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
              const Text('Your journals',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700 ,
              ),),
              Padding(padding: customTopPadding(0.1)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DrawerCard(title: 'Title'),
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
            height: 200,
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

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.blue.shade200,
            Colors.purple.shade100,
          ])),
      child: const Drawer(),
    ));
  }
}
