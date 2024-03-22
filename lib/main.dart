import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
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

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  var currentItem = Item.getRandomItem();
  var guessHistory = <Guess>[];
  double currentGuess = 0.0;

  void getNext() {
    guessHistory.add(Guess(item: currentItem, guessedPrice: currentGuess));
    currentItem = Item.getRandomItem();
    notifyListeners();
  }

  var favorites = <WordPair>{};

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
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
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
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
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
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
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var item = appState.currentItem;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3),
          SizedBox(height: 10),
          GuesserCard(item: item),
          SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: HistoryView(),
          ),
        ],
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
            "${guess.item.name} - ${guess.guessedPrice - guess.item.price}€",
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
          width: 300,
          child: Card(
            color: theme.colorScheme.primary,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.network(
                    widget.item.imageUrl,
                    width: 100, // Adjust width as needed
                    height: 100, // Adjust height as needed
                    fit: BoxFit.cover, // Adjust the fit of the image
                  ),
                  Text(
                    widget.item.name,
                    style: style,
                    semanticsLabel: widget.item.name,
                  ),
                  Text(
                    "${widget.item.price}€",
                    style: style,
                    semanticsLabel: "${widget.item.price}€",
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 200,
          child: TextField(
              focusNode: _focusNode,
              onSubmitted: (String value) {
                double guess = double.parse(_controller.text);
                appState.addGuess(guess);
              },
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your guess !',
                border: OutlineInputBorder(),
              )),
        ),
        SizedBox(height: 20),
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Your ${appState.favorites.length} favorites:"),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete_outline),
              color: theme.colorScheme.primary,
              onPressed: () {
                appState.toggleFavorite(pair);
              },
            ),
            title: Text(pair.asPascalCase),
          ),
      ],
    );
  }
}
