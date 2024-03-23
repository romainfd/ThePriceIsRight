import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/item.dart';
import 'models/guess.dart';
import 'screens/my_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'The Price Is Right App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String _itemType = defaultItemType; // Private variable to store itemType
  var currentItem = ItemDict.getRandomItem(defaultItemType);
  var guessHistory = <Guess>[];
  double currentGuess = 0.0;

  String get itemType => _itemType; // Getter for itemType

  void setItemType(String type) {
    _itemType = type;
    // notifyListeners(); // Notify listeners of the change
  }

  void getNext() {
    guessHistory.add(Guess(item: currentItem, guessedPrice: currentGuess));
    currentItem = ItemDict.getRandomItem(_itemType);
    notifyListeners();
  }

  void addGuess(double guess) {
    currentGuess = guess;
    getNext();
  }
}
