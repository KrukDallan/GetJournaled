import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';
import 'package:getjournaled/db/bindings.dart';
import 'package:getjournaled/notes/note_main_page.dart';
import 'package:provider/provider.dart';

import 'package:getjournaled/welcome.dart';
import 'package:getjournaled/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bindDependencies();
  await GetIt.I<NoteService>().open();
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
  // TODO: fix dark mode colors
  final ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          routes: {'NotesPage': (context) => const NotesPage()},
          title: 'GetClocked',
          theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Roboto',
              colorScheme: const ColorScheme(
                  brightness: Brightness.light,
                  primary: Color.fromARGB(255, 227, 247, 252),
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
          home: const MyHomePage(
            title: 'GetClocked',
            page: WelcomePage(),
          ),
        ));
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  final String title;
  final Widget page;
  const MyHomePage({
    super.key,
    required this.title,
    required this.page,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

    Widget page = widget.page;

    switch (selectedIndex) {
      case 0:
        page = const WelcomePage();
      case 1:
        page = const DrawerPage();
      case 2:
        page = const NotesPage();
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
            return Scaffold(
              bottomNavigationBar: NavigationBar(
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                indicatorColor: Colors.transparent,
                backgroundColor: Colors.grey.shade800,
                indicatorShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(0, 0))),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Home Page',
                      style: TextStyle(
                        color: (selectedIndex == 0)
                            ? Colors.cyanAccent.shade100
                            : Colors.white,
                      ),
                    ).data!,
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.article,
                    ),
                    label: 'Drawer',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.note_alt_rounded,
                    ),
                    label: 'Notes',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.settings,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
              body: page,
            );
            /*  return Column(
              children: [
                Expanded(child: mainArea),
                NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                    indicatorColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(
                          Icons.home_filled,
                        ),
                        label: 'Home page',
                      ),
                      NavigationDestination(
                        icon: Icon(
                          Icons.article,
                        ),
                        label: 'Drawer',
                      ),
                      NavigationDestination(
                        icon: Icon(
                          Icons.note_alt_rounded,
                        ),
                        label: 'Notes',
                      ),
                      NavigationDestination(
                        icon: Icon(
                          Icons.settings,
                        ),
                        label: 'Settings',
                      ),
                    ],
                    ),
              ],
            ); */
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
                        icon: Icon(Icons.home_filled,
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
                        icon: const Icon(Icons.note_alt_outlined),
                        label: Text('Notes',
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
