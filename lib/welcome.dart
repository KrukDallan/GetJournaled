import 'package:flutter/material.dart';
import 'package:getjournaled/shared.dart';
import 'package:getjournaled/notes.dart';

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
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: customTopPadding(0.1)),
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 45,
                fontFamily: 'Lobster',
              ),
            ),
          ),
          Padding(padding: customTopPadding(0.4)),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(180, 50)),
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
          Padding(padding: customTopPadding(0.05)),
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(180, 50)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleNotePage(
                              title: 'Title',
                              body: '',
                              id: 0,
                            )));
              },
              child: Text(
                'New note',
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
