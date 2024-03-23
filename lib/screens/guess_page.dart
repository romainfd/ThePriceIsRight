import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/guesser_card.dart';
import '../components/history_view.dart';
import '../components/score_view.dart';
import '../main.dart';

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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.code),
                onPressed: () {
                  _launchURL(
                      'https://github.com/romainfd/ThePriceIsRight'); // Replace URL with your desired website
                },
              ),
            ),
          ),
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

  // Function to launch the URL
  Future<void> _launchURL(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}
