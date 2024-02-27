class Item {
  final String id;
  final String name;
  final String tamilName;
  int price;
  final String category;
  final String imagePath;
  final int counterId;
  int itemCounter;
  int status;

  Item(
      {required this.id,
      required this.name,
      required this.tamilName,
      required this.price,
      required this.category,
      required this.imagePath,
      required this.counterId,
      required this.status,
      this.itemCounter = 0});
}

class Bill {
  final String id;
  final int totalPrice;
  final List<Item> items;
  final int counterId;
  final String dateTime;

  Bill(
      {required this.id,
      required this.totalPrice,
      required this.items,
      required this.counterId,
      required this.dateTime});
}
