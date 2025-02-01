import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/add_product_dialog.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class InventoryPage extends StatefulWidget {
  final bool autoTriggerAddProduct;

  const InventoryPage({super.key, this.autoTriggerAddProduct = false});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Product> products = [
    Product(
      name: 'Product 1',
      description: 'This is a description for product 1.',
      price: 29.99,
      quantity: 10,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Product(
      name: 'Product 2',
      description: 'This is a description for product 2.',
      price: 49.99,
      quantity: 0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Product(
      name: 'Product 3',
      description: 'This is a description for product 3.',
      price: 99.99,
      quantity: 5,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
  ];

  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  String _filterType = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    if (widget.autoTriggerAddProduct) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addProduct();
      });
    }
  }

  void _addProduct() async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onProductAdded: (product) {
          setState(() {
            products.add(product);
          });
        },
      ),
    );
  }

  void _editProduct(Product product) async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        product: product,
        onProductAdded: (updatedProduct) {
          setState(() {
            product.name = updatedProduct.name;
            product.description = updatedProduct.description;
            product.price = updatedProduct.price;
            product.quantity = updatedProduct.quantity;
            product.imageUrl = updatedProduct.imageUrl;
          });
        },
      ),
    );
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search... ",
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        onChanged: (text) => _searchProducts(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Filter Tags
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterTag('All'),
                          _buildFilterTag('Empty Stock'),
                          _buildFilterTag('Low Stock'),
                          _buildFilterTag('High Stock'),
                          _buildFilterTag('Price: Low to High'),
                          _buildFilterTag('Price: High to Low'),
                          _buildFilterTag('Quantity: Low to High'),
                          _buildFilterTag('Quantity: High to Low'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.isEmpty
                      ? _getFilteredProducts().length
                      : _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults.isEmpty
                        ? _getFilteredProducts()[index]
                        : _searchResults[index];
                    return ProductCard(
                      product: product,
                      onEdit: () => _editProduct(product),
                      onDelete: () => _deleteProduct(index),
                    );
                  },
                ),
              ),
            ],
          ),
          // Add Product Button
          Positioned(
            bottom: 25,
            right: 20,
            child: ElevatedButton(
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff4c345),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(40, 40),
              ),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a filter tag
  Widget _buildFilterTag(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              _filterType == label ? const Color(0xfff4c345) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _filterType == label ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Filter products based on the selected filter type
  List<Product> _getFilteredProducts() {
    switch (_filterType) {
      case 'Empty Stock':
        return products.where((product) => product.quantity == 0).toList();
      case 'Low Stock':
        return products.where((product) => product.quantity <= 5).toList();
      case 'High Stock':
        return products.where((product) => product.quantity > 5).toList();
      case 'Price: Low to High':
        return List.from(products)..sort((a, b) => a.price.compareTo(b.price));
      case 'Price: High to Low':
        return List.from(products)..sort((a, b) => b.price.compareTo(a.price));
      case 'Quantity: Low to High':
        return List.from(products)
          ..sort((a, b) => a.quantity.compareTo(b.quantity));
      case 'Quantity: High to Low':
        return List.from(products)
          ..sort((a, b) => b.quantity.compareTo(a.quantity));
      default:
        return products;
    }
  }

  // Search products
  void _searchProducts() {
    setState(() {
      _searchResults = _getFilteredProducts()
          .where((product) =>
              product.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }
}
