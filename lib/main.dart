import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'item.dart';
import 'guess.dart';

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

const String defaultItemType = "home";

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

class GuessPage extends StatelessWidget {
  final String itemType;

  GuessPage({required this.itemType});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.setItemType(itemType);
    var item = appState.currentItem;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          ScoreView(),
          Spacer(flex: 1),
          GuesserCard(item: item),
          SizedBox(height: 30),
          Expanded(
            flex: 4,
            child: HistoryView(),
          ),
        ],
      ),
    );
  }
}

class ScoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var totalScore = appState.guessHistory.isEmpty
        ? 0
        : appState.guessHistory
            .map((guess) => guess.score)
            .reduce((value, element) => value + element);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(80.0), // Adjust the radius as needed
      ),
      color: theme.colorScheme.onPrimary,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          totalScore.toStringAsFixed(0),
          style: style,
          semanticsLabel: totalScore.toString(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var history = appState.guessHistory.reversed;

    // Avoid overflow | Ref.: https://stackoverflow.com/a/64121579/10115198
    return Wrap(children: [
      for (var guess in history)
        Center(
          child: Text(
            "${guess.item.name} (${guess.item.price}€) - guessed at ${guess.guessedPrice}€ - score: +${guess.score.toStringAsFixed(0)}",
            semanticsLabel: guess.item.name,
          ),
        ),
    ]);
  }
}

class GuesserCard extends StatefulWidget {
  const GuesserCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<GuesserCard> createState() => _GuesserCardState();
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'\d+(\.\d{0,2})?');
    final String newString = regEx.stringMatch(newValue.text) ?? '';
    return newString == newValue.text ? newValue : oldValue;
  }
}

class _GuesserCardState extends State<GuesserCard> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Column(
      children: [
        Container(
          width: 500,
          margin: EdgeInsets.symmetric(horizontal: 20), // for mobile view
          child: Card(
            color: theme.colorScheme.primary,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Image.network(
                    widget.item.imageUrl,
                    width: 400, // Adjust width as needed
                    height: 100, // Adjust height as needed
                    fit: BoxFit.contain, // Adjust the fit of the image
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.item.name,
                    style: style,
                    semanticsLabel: widget.item.name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Container(
          width: 200,
          child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                DecimalTextInputFormatter()
              ],
              focusNode: _focusNode,
              onSubmitted: (String value) {
                double guess = double.parse(_controller.text);
                appState.addGuess(guess);
              },
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: '€',
                contentPadding: EdgeInsets.symmetric(horizontal: 35.0),
                labelText: 'Enter your guess',
                border: OutlineInputBorder(),
              )),
        ),
        SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              double guess = double.parse(_controller.text);
              appState.addGuess(guess);
            }
          },
          icon: Icon(Icons.send),
          label: Text('Guess'),
        ),
      ],
    );
  }
}
