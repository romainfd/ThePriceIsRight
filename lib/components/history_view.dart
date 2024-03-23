import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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
