class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}