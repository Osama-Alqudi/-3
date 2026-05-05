
// ملاحظة: تأكد أنك أنشأت ملف product.dart وملف shop_provider.dart بنفس هذه الأسماء
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/shop_provider.dart';
import './model/product.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => ShopProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const MainBottomNav(),
    );
  }
}

// --- شاشة التحكم في التنقل ---
class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1F1F1F),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

// --- 1. شاشة المتجر الرئيسية ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب البيانات من البروفايدر
    final shopData = Provider.of<ShopProvider>(context);
    final products = shopData.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Aura Shop')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          childAspectRatio: 0.70, 
          crossAxisSpacing: 10, 
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ProductItem(product: products[i]),
      ),
    );
  }
}

// --- تصميم كرت المنتج ---
class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                Text('\$${product.price}', style: const TextStyle(color: Colors.blueAccent)),


Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      onPressed: () => shop.toggleFavorite(product.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                      onPressed: () {
                        shop.addToCart(product.id);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart!'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- 2. شاشة التصنيفات ---
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Electronics', 'Fashion', 'Sports', 'Perfumes', 'Books'];
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 15, mainAxisSpacing: 15
        ),
        itemCount: categories.length,
        itemBuilder: (ctx, i) => Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800, 
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade900])
          ),
          alignment: Alignment.center,
          child: Text(categories[i], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// --- 3. شاشة المفضلة ---
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<ShopProvider>(context).favoriteItems;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: favorites.isEmpty 
        ? const Center(child: Text('No favorites yet!'))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(favorites[i].imageUrl, width: 50, height: 50, fit: BoxFit.cover)
              ),
              title: Text(favorites[i].title),
              subtitle: Text('\$${favorites[i].price}'),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => Provider.of<ShopProvider>(context, listen: false).toggleFavorite(favorites[i].id),
              ),
            ),
          ),
    );
  }
}

// --- 4. شاشة السلة ---
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);
    final cartItems = shop.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty 
            ? const Center(child: Text('Your cart is empty!'))
            : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                String productId = cartItems.keys.elementAt(i);
                int quantity = cartItems.values.elementAt(i);
                // جلب بيانات المنتج بناءً على الـ ID الموجود في السلة
                final product = shop.items.firstWhere((p) => p.id == productId);


return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    leading: Image.network(product.imageUrl, width: 50),
                    title: Text(product.title),
                    subtitle: Text('Total: \$${(product.price * quantity).toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => shop.decrementQuantity(productId)),
                        Text('$quantity', style: const TextStyle(fontSize: 16)),
                        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => shop.addToCart(productId)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1F1F1F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total Amount', style: TextStyle(color: Colors.grey)),
                    Text('\$${shop.totalAmount.toStringAsFixed(2)}', 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {}, 
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: const Text('Checkout')
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}