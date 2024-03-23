import 'item.dart';

class Guess {
  Item item;
  double guessedPrice;

  Guess({
    required this.item,
    required this.guessedPrice,
  });

  double get score => 100 * (guessedPrice - item.price).abs();
}
