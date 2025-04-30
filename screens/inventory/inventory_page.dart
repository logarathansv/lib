import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../utils/predefined_products.dart';
import '../../models/product_model/product_model.dart';
import '../../providers/product_provider.dart';
import '../../utils/add_product_dialog.dart';
import '../../widgets/product_card.dart';

class InventoryPage extends ConsumerStatefulWidget {
  final bool autoTriggerAddProduct;

  const InventoryPage({super.key, this.autoTriggerAddProduct = false});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  List<Product> products = [];
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  String _filterType = 'All';
  bool _isSearching = false;
  bool _showAddProducts = false;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
      if (widget.autoTriggerAddProduct) {
        setState(() {
          _showAddProducts = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getProducts() async {
    final productsAsync = ref.watch(getProductsProvider);
    productsAsync.when(
      data: (fetchedProducts) {
        setState(() {
          products = fetchedProducts;
        });
      },
      error: (error, stackTrace) {
        print("Error loading products: $error");
        return [];
      },
      loading: () => CircularProgressIndicator(),
    );
  }

  void _addProduct() async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onProductAdded: (product) {
          ref.invalidate(getProductsProvider);
        },
        onProductUpdated: (product) {},
      ),
    );
  }

  void _addPredefinedProduct(PredefinedProduct predefinedProduct) async {
    final product = Product(
      name: predefinedProduct.name,
      description: predefinedProduct.description,
      price: predefinedProduct.price,
      quantity: '0',
      imageUrl: predefinedProduct.imageUrl,
      units: predefinedProduct.units,
    );

    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        product: product,
        onProductAdded: (product) {
          ref.invalidate(getProductsProvider);
        },
        onProductUpdated: (product) {},
      ),
    );
  }

  void _editProduct(Product product) async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        product: product,
        onProductUpdated: (updatedProduct) {
          setState(() {
            int index = products.indexWhere((p) => p.id == product.id);
            if (index != -1) {
              products[index] = Product(
                id: updatedProduct.id,
                name: updatedProduct.name,
                description: updatedProduct.description,
                price: updatedProduct.price,
                quantity: updatedProduct.quantity,
                imageUrl: updatedProduct.imageUrl,
                units: updatedProduct.units
              );
            }
          });
          ref.invalidate(getProductsProvider);
        },
        onProductAdded: (updatedProduct) {},
      ),
    );
  }

  void _deleteProduct(int index) async {
    final product = products[index];
    try {
      await ref.read(productApiProvider.future).then((productService) {
        return productService.deleteProduct(product.id!);
      });
      ref.invalidate(getProductsProvider);
      setState(() {
        products.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} deleted successfully')),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to delete product: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(getProductsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Row(
          children: [
            Text(
              _showAddProducts ? 'Add Products' : 'My Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (!_showAddProducts)
              Text(
                ' (${products.length})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        actions: [
          if (_showAddProducts)
            TextButton.icon(
              onPressed: _addProduct,
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xfff4c345),
                size: 20,
              ),
              label: const Text(
                'Custom',
                style: TextStyle(
                  color: Color(0xfff4c345),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchResults.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchResults.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (text) {
                    _searchProducts();
                  },
                ),
              ),
            ),
          if (!_isSearching && !_showAddProducts)
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterTag('All'),
                  _buildFilterTag('Empty Stock'),
                  _buildFilterTag('Low Stock'),
                  _buildFilterTag('High Stock'),
                  _buildFilterTag('Price: Low to High'),
                  _buildFilterTag('Price: High to Low'),
                ],
              ),
            ),
          if (_showAddProducts)
            Container(
              height: 64,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: predefinedCategories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCategoryChip('All');
                  }
                  final category = predefinedCategories[index - 1];
                  return _buildCategoryChip(category.name);
                },
              ),
            ),
          Expanded(
            child: productsAsync.when(
              data: (fetchedProducts) {
                products = fetchedProducts;
                return _showAddProducts 
                    ? _buildPredefinedProductsGrid()
                    : _buildProductList();
              },
              error: (error, stackTrace) => Center(child: Text("Error: $error")),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showAddProducts = !_showAddProducts;
            _selectedCategory = 'All';
          });
        },
        backgroundColor: const Color(0xfff4c345),
        child: Icon(
          _showAddProducts ? Icons.close : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final displayProducts = _searchResults.isEmpty && _searchController.text.isEmpty
        ? _getFilteredProducts()
        : _searchResults;

    if (displayProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ProductCard(
            product: product,
            onEdit: () => _editProduct(product),
            onDelete: () => _deleteProduct(index),
          ),
        );
      },
    );
  }

  Widget _buildPredefinedProductsGrid() {
    final filteredProducts = _getFilteredPredefinedProducts();
    
    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products in this category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a different category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildPredefinedProductCard(product);
      },
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Material(
        elevation: isSelected ? 2 : 0,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xfff4c345) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? const Color(0xfff4c345) : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xfff4c345).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category != 'All')
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      predefinedCategories
                          .firstWhere((c) => c.name == category)
                          .icon,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PredefinedProduct> _getFilteredPredefinedProducts() {
    if (_selectedCategory == 'All') {
      return predefinedCategories.expand((category) => category.products).toList();
    }
    return predefinedCategories
        .firstWhere((category) => category.name == _selectedCategory)
        .products;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to your inventory',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addProduct,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff4c345),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          color: _filterType == label ? const Color(0xfff4c345) : Colors.grey[300],
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

  List<Product> _getFilteredProducts() {
    switch (_filterType) {
      case 'Empty Stock':
        return products.where((product) => product.quantity == '0').toList();
      case 'Low Stock':
        return products.where((product) => int.parse(product.quantity) <= 5).toList();
      case 'High Stock':
        return products.where((product) => int.parse(product.quantity) > 5).toList();
      case 'Price: Low to High':
        return List.from(products)..sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      case 'Price: High to Low':
        return List.from(products)..sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
      default:
        return products;
    }
  }

  void _searchProducts() {
    setState(() {
      _searchResults = products
          .where((product) =>
              product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              (product.description?.toLowerCase() ?? "").contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Widget _buildPredefinedProductCard(PredefinedProduct product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _addPredefinedProduct(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xfff4c345),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xfff4c345),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product.price}/${product.units}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xfff4c345),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
