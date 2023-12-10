import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getjournaled/shared.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.amberAccent[200]!,
            Colors.purple[200]!,
          ]
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: customTopPadding(0.25)),
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 30,
                fontFamily: 'Lobster',
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.1)),
          Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
            Colors.blue.shade100,
            Colors.purple.shade100,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: TextButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith((states) => const Size(180, 50)),
            ),
            onPressed: () {}, 
            child: Text(
                  'New journal',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
      ),
        ],
      ),
    ));
  }
}
