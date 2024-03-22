import 'dart:math';

List<Item> itemList = [
  Item(imageUrl: 'url1', name: 'Item 1', price: 10.0),
  Item(imageUrl: 'url2', name: 'Item 2', price: 20.0),
  Item(imageUrl: 'url3', name: 'Item 3', price: 30.0),
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
