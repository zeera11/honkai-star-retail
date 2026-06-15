class Item {
  final int id;
  final String name;

  final String type;
  final String label;

  final String desc;
  int stock;
  final int price;

  final String emoji;
  final String? imagePath;

  final String rarity;
  final String category;

  final String? eventTag;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.label,
    required this.desc,
    required this.stock,
    required this.price,
    required this.emoji,
    this.imagePath,
    required this.rarity,
    required this.category,
    this.eventTag,
  });
}
