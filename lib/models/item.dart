import 'dart:math';

class Item {
  String imageUrl;
  String name;
  double price;

  Item({
    required this.imageUrl,
    required this.name,
    required this.price,
  });
}

class ItemDict {
  static Map<String, List<Item>> itemDict = {
    'home': [
      Item(
        imageUrl: 'https://pngimg.com/d/lamp_PNG108698.png',
        name: 'Table lamp',
        price: 19.99,
      ),
      Item(
        imageUrl:
            'https://i.pinimg.com/originals/1b/9f/8b/1b9f8b4f4d1b6c1ceff8d7c133fb5eda.png',
        name: 'Pillow',
        price: 25.99,
      ),
      // Add more home items as needed
    ],
    'food': [
      Item(
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/027/216/290/original/red-carrot-red-carrot-transparent-background-ai-generated-free-png.png',
        name: '1kg of carrots',
        price: 1.29,
      ),
      Item(
        imageUrl:
            'https://www.nutella.com/il/sites/nutella20_il/files/2021-05/jar-750g.png',
        name: '1kg of Nutella',
        price: 6.09,
      ),
      // Add more food items as needed
    ],
  };

  static Item getRandomItem(String itemType) {
    if (itemType == 'all') {
      // Get a random key from the map
      List<String> keys = itemDict.keys.toList();
      itemType = keys[Random().nextInt(keys.length)];
    }
    final List<Item>? itemList = itemDict[itemType];
    if (itemList == null || itemList.isEmpty) {
      throw Exception('No items found for the specified type');
    }

    final randomIndex = Random().nextInt(itemList.length);
    return itemList[randomIndex];
  }
}
