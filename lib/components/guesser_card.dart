import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/item.dart';
import '../utils/decimal_text_input_formatter.dart';

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
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
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
