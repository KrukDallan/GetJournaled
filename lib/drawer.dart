import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';

class Drawer extends StatefulWidget{
    @override
  State<Drawer> createState() => _Drawer();
}

class _Drawer extends State<Drawer>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: topPadding),
              Center(child:Text('Your drawer')),
            ],
          ),
        ),
      );
  }
}

class DrawerPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue[200]!,
            Colors.purple[200]!,
          ]
        )
        ),
        child: Drawer(),
      ));
  }

}