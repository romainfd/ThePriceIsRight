import 'package:flutter/material.dart';

import 'guess_page.dart';

const String defaultItemType = "all";

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String itemType;
    switch (selectedIndex) {
      case 0:
        itemType = defaultItemType;
        break;
      case 1:
        itemType = "home";
        break;
      case 2:
        itemType = "food";
        break;
      default:
        throw UnimplementedError('no itemType for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.all_inbox),
                    label: Text('All'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.fastfood),
                    label: Text('Food'),
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
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: GuessPage(itemType: itemType),
              ),
            ),
          ],
        ),
      );
    });
  }
}
