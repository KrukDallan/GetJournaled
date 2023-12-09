import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:getjournaled/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState(); 

  // Needed for light/dark theme
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  //final ThemeMode _themeMode = ThemeMode.system;
  final ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'GetClocked',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                  brightness: Brightness.light,
                  primary: Color.fromARGB(255, 33, 195, 236),
                  onPrimary: Colors.black,
                  secondary: Colors.white,
                  onSecondary: Colors.black,
                  tertiary: Colors.blue,
                  onTertiary: Colors.white,
                  error: Colors.black,
                  onError: Colors.red,
                  background: Colors.white,
                  onBackground: Colors.black,
                  surface: Colors.white,
                  onSurface: Colors.black)),
          darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                  brightness: Brightness.dark,
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  secondary: Color.fromARGB(255, 29, 28, 28),
                  onSecondary: Colors.white,
                  tertiary: Color.fromARGB(255, 29, 28, 28),
                  onTertiary: Colors.white,
                  error: Color.fromARGB(255, 29, 28, 28),
                  onError: Colors.red,
                  background: Colors.black,
                  onBackground: Colors.white,
                  surface: Color.fromARGB(255, 53, 51, 55),
                  onSurface: Colors.white)),
          themeMode: _themeMode,
          home: const MyHomePage(title: 'GetClocked'),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const WelcomePage();
      default:
        page = Text('UnimplementedError(no widget for $selectedIndex)');
    }

    var mainArea = ColoredBox(
      color: colorScheme.primary,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(
              children: [
                Expanded(child: mainArea),
                 BottomNavigationBar(
                      unselectedItemColor: colorScheme.onPrimary,
                      selectedItemColor: colorScheme.onPrimary,
                      backgroundColor: colorScheme.secondary,
                      items: [
                        BottomNavigationBarItem(
                          backgroundColor: colorScheme.secondary,
                          icon: Icon(
                            Icons.access_time_filled,
                            color: colorScheme.onPrimary,
                          ),
                          label: 'Home page',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.article,
                          ),
                          label: 'Drawer',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.settings,
                          ),
                          label: 'Settings',
                        ),
                      ],
                      currentIndex: selectedIndex,
                      onTap: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      }),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: colorScheme.surface,
                    extended: constraints.maxWidth >= 700,
                    indicatorColor: colorScheme.primary,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.access_time_filled,
                            color: colorScheme.onSecondary),
                        label: Text(
                          'Home page',
                          style: TextStyle(color: colorScheme.onSecondary),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.article),
                        label: Text('Drawer',
                            style: TextStyle(color: colorScheme.onSecondary)),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings),
                        label: Text('Settings',
                            style: TextStyle(color: colorScheme.onSecondary)),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
