import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';

class Drawer extends StatefulWidget {
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
              Padding(padding: customTopPadding(0.1)),
              const Text('Your drawer'),
              Padding(padding: customTopPadding(0.1)),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            height: 200,
                            child: Center(child: Text('sample')),
                            ),
                        ],
                      ),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            height: 200,
                            child: Center(child: Text('sample')),
                            ),
                        ],
                      ),
                  ),
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
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.blue[200]!,
            Colors.purple[200]!,
          ])),
      child: Drawer(),
    ));
  }
}
