import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ThemeData;
import 'package:kabinet_froshy/pages/homePage.dart';
import 'package:kabinet_froshy/pages/ListPage.dart';
import 'package:kabinet_froshy/pages/aboutUs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  runApp(
    FluentApp(
      theme: ThemeData.dark(),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );

  //windows title bar hiding and ...
  doWhenWindowReady(() {
    const initialSize = Size(1280, 720);
    appWindow.minSize = const Size(1280, 720);

    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        actions: Row(
          children: [
            Expanded(child: MoveWindow()),
            MinimizeWindowButton(
              colors: WindowButtonColors(
                  iconNormal: const Color.fromARGB(255, 173, 173, 173)),
            ),
            MaximizeWindowButton(
              colors: WindowButtonColors(
                  iconNormal: const Color.fromARGB(255, 173, 173, 173)),
            ),
            CloseWindowButton(animate: true),
          ],
        ),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        selected: _currentPage,
        onChanged: (value) => setState(() {
          _currentPage = value;
        }),
        items: <NavigationPaneItem>[
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('مدل های موجود '),
            body: const HomePage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.list),
            title: const Text('لیست فروش'),
            body: const ListPage(),
          ),
          PaneItem(
            icon: const Icon(Icons.contact_support),
            title: const Text('درباره سازنده'),
            body: AboutUs(),
          ),
        ],
      ),
    );
  }
}
