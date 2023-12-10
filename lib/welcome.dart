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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: topPadding),
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
            
          ),
          const Expanded(child: Text('')),

        ],
      ),
    ));
  }
}
