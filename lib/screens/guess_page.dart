import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
