import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  List<Category> categories = [];
  bool isLoading = true;
  String baseUrl = "http://10.0.2.2/UAS_MOBILE";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          categories = List<Category>.from(
            data['data'].map((x) => Category.fromJson(x))
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kategori: $e')),
      );
    }
  }

  // Map icon berdasarkan nama kategori
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'makanan':
        return Icons.fastfood;
      case 'minuman':
        return Icons.local_drink;
      case 'sembako':
        return Icons.shopping_basket;
      case 'kebutuhan ibu dan anak':
      case 'ibu & anak':
        return Icons.child_care;
      case 'kebutuhan rumah tangga':
      case 'rumah tangga':
        return Icons.cleaning_services;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distributor App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat datang, Client 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (categories.isEmpty)
              const Center(child: Text('Tidak ada kategori tersedia'))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      category: categories[index],
                      onTap: () {
                        // Navigasi ke halaman produk berdasarkan kategori
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              categoryId: categories[index].id,
                              categoryName: categories[index].name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getCategoryIcon(category.name), // Fungsi untuk mapping icon
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'makanan':
        return Icons.fastfood;
      case 'minuman':
        return Icons.local_drink;
      case 'sembako':
        return Icons.shopping_basket;
      case 'kebutuhan ibu dan anak':
      case 'ibu & anak':
        return Icons.child_care;
      case 'kebutuhan rumah tangga':
      case 'rumah tangga':
        return Icons.cleaning_services;
      default:
        return Icons.category;
    }
  }
}

// Model untuk Kategori
class Category {
  final int id;
  final String name;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}

// Model untuk Produk
class Product {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? photo;
  final String createdAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.photo,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'] ?? '',
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      photo: json['photo'],
      createdAt: json['created_at'],
    );
  }
}

// Halaman Produk berdasarkan Kategori
class ProductPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductPage({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoading = true;
  String baseUrl = "http://your-domain.com/api"; // Ganti dengan URL API Anda

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?category_id=${widget.categoryId}'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          products = List<Product>.from(
            data['data'].map((x) => Product.fromJson(x))
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('Tidak ada produk tersedia'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: product.photo != null
                            ? Image.network(
                                product.photo!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 50),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.description),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text('Stok: ${product.stock}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Tambah ke cart
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} ditambahkan ke cart'),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}