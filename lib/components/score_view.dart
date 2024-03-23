import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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
