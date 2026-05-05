import 'package:flutter/material.dart';
import 'package:flutter_active/model/product.dart';

class ShopProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(id: 'p1', title: 'Aura Headphones', price: 145.00, imageUrl: 'https://picsum.photos/200'),
    Product(id: 'p2', title: 'Nova Smart Watch', price: 129.90, imageUrl: 'https://picsum.photos/201'),
    Product(id: 'p3', title: 'Velvet Perfume', price: 74.99, imageUrl: 'https://picsum.photos/202'),
    Product(id: 'p4', title: 'Leather Bag', price: 59.99, imageUrl: 'https://picsum.photos/203'),
  ];

  final Map<String, int> _cartItems = {};

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();
  Map<String, int> get cartItems => _cartItems;

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((key, quantity) {
      final Product = _items.firstWhere((prod) => prod.id == key);
      total += Product.price * quantity;
    });
    return total;
  }

  void toggleFavorite(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index != -1) {
      _items[index].isFavorite = !_items[index].isFavorite;
      notifyListeners();
    }
  }

  void addToCart(String ProductId) {
    if (_cartItems.containsKey(ProductId)) {
      _cartItems.update(ProductId, (existing) => existing + 1);
    } else {
      _cartItems.putIfAbsent(ProductId, () => 1);
    }
    notifyListeners();
  }

  void removeFromCart(String ProductId) {
    _cartItems.remove(ProductId);
    notifyListeners();
  }

  void decrementQuantity(String ProductId) {
    if (!_cartItems.containsKey(ProductId)) return;
    if (_cartItems[ProductId]! > 1) {
      _cartItems.update(ProductId, (existing) => existing - 1);
    } else {
      _cartItems.remove(ProductId);
    }
    notifyListeners();
  }
}