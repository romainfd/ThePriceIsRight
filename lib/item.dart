import 'dart:math';

List<Item> itemList = [
  Item(
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/027/216/290/original/red-carrot-red-carrot-transparent-background-ai-generated-free-png.png',
      name: '1kg de carottes',
      price: 1.86),
  Item(
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/027/216/290/original/red-carrot-red-carrot-transparent-background-ai-generated-free-png.png',
      name: 'Item 2',
      price: 20.0),
  Item(
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/027/216/290/original/red-carrot-red-carrot-transparent-background-ai-generated-free-png.png',
      name: 'Item 3',
      price: 30.0),
];

class Item {
  String imageUrl;
  String name;
  double price;

  Item({
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  static Item getRandomItem() {
    final randomIndex = Random().nextInt(itemList.length);
    return itemList[randomIndex];
  }
}
