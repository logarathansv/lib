import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/utils/add_existing_dialog.dart';

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
  List<Map<String, dynamic>> _importedProducts = [];
  bool _isImporting = false;
  List<Product> products = [];
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;
  bool _showAddProducts = false;
  var filteredProducts = <ProductInventory>[];

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

  Future<void> _importProducts() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
        allowMultiple: false,
        withData: true, // Ensure we get the file data
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final file = result.files.first;
      if (file.bytes == null || file.bytes!.isEmpty) {
        throw Exception('File is empty or could not be read');
      }

      setState(() => _isImporting = true);
      final bytes = file.bytes!;
      final filename = file.name;

      List<Map<String, dynamic>> products = [];

      if (filename.endsWith('.csv')) {
          final csv = const CsvToListConverter().convert(String.fromCharCodes(bytes));
          // Skip header row and validate row data
          for (var i = 1; i < csv.length; i++) {
            if (csv[i].length >= 3) {
              products.add({
                'name': csv[i][0]?.toString() ?? '',
                'price': csv[i][1]?.toString() ?? '0',
                'quantity': csv[i][2]?.toString() ?? '0',
              });
            }
          }
        } else if (filename.endsWith('.xlsx')) {
          final excel = Excel.decodeBytes(bytes);
          if (excel.tables.isEmpty) {
            throw Exception('Excel file has no sheets');
          }
          final sheet = excel.tables[excel.tables.keys.first]!;
          // Skip header row
          for (var i = 1; i < sheet.maxRows; i++) {
            final name = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i)).value;
            final price = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).value;
            final quantity = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i)).value;
            
            if (name != null) {
              products.add({
                'name': name.toString(),
                'price': price?.toString() ?? '0',
                'quantity': quantity?.toString() ?? '0',
              });
            }
          }
        }

        // Match products with inventory
        final inventoryProducts = await ref.read(getInventoryProvider.future);
        List<Map<String, dynamic>> matchedProducts = [];
        List<Map<String, dynamic>> newProducts = [];

        for (var product in products) {
          try {
            final match = inventoryProducts.firstWhere(
              (p) => p.name.toLowerCase() == product['name'].toString().toLowerCase(),
            );
            matchedProducts.add({...product, 'matched': match});
          } catch (e) {
            newProducts.add(product);
          }
        }

        if (matchedProducts.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setDialogState) => AlertDialog(
                title: const Text('Matching Products Found'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: matchedProducts.length,
                    itemBuilder: (context, index) {
                      final product = matchedProducts[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Price: \$${product['price']} - Quantity: ${product['quantity']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setDialogState(() {
                              matchedProducts.removeAt(index);
                              newProducts.add(product);
                              if (matchedProducts.isEmpty) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff4c345),
                  ),
                  child: const Text('Update Products'),
                ),
              ],
            ),
            )
          );
        }
        // Restructure products for batch import
        final List<Map<String, dynamic>> batchProducts = [...matchedProducts].map((product) {
          final filteredProduct = filteredProducts.firstWhere(
            (p) => p.name.toLowerCase() == product['name'].toString().toLowerCase(),
          );
          print(product);
          print(filteredProduct);
          return {
            'productId': filteredProduct.id,
            'price': product['price'],
            'quantity': product['quantity'],
          };
        }).toList();

        // Batch import products
        await ref.read(productApiProvider.future).then((service) {
          return service.addProducts(batchProducts);
        });

        // Show success toast
        Fluttertoast.showToast(
          msg: 'Successfully imported ${batchProducts.length} products',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Refresh products list
        ref.invalidate(getProductsProvider);
      
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error importing products: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isImporting = false);
    }
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
      loading: () => const CircularProgressIndicator(),
    );
  }

  void _addProduct() async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onProductAdded: (product) {
          ref.invalidate(getInventoryProvider);
        },
        onProductUpdated: (product) {},
      ),
    );
  }

  void _addExistingProduct(ProductInventory existingProduct) async {
    // Convert ProductInventory to Product
    final product = Product(
      id: existingProduct.id,
      name: existingProduct.name,
      description: existingProduct.description,
      imageUrl: existingProduct.imageUrl,
      units: existingProduct.units,
      price: '0', // Default price when adding from inventory
      quantity: '0', // Default quantity when adding from inventory
      isVerified: existingProduct.isVerified,
    );

    await showDialog(
      context: context,
      builder: (context) => AddExistingProductDialog(
        product: product, // Pass the converted Product object
        onProductAdded: (product) {
          ref.invalidate(getProductsProvider);
        },
        onProductUpdated: (product) {},
        flag : false
      ),
    );
  }

  void _editProduct(Product product) async {
    await showDialog(
      context: context,
      builder: (context) => AddExistingProductDialog(
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
                units: updatedProduct.units,
                isVerified: updatedProduct.isVerified
              );
            }
          });
          ref.invalidate(getProductsProvider);
        },
        onProductAdded: (updatedProduct) {},
        flag : true
      ),
    );
  }

  void _deleteProduct(int index) async {
    final product = products[index];
    print(product.name);
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
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: Hero(
          tag: 'back_button',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft03,
                color: Colors.black,
                size: 24.0,
              ),
            ),
          ),
        ),
        title: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: Row(
                  children: [
                    Text(
                      _showAddProducts ? 'Add Products' : 'My Products',
                      style: const TextStyle(
                        fontSize: 20,
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
              ),
            );
          },
        ),
        actions: [
          if (_showAddProducts)
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOut,
              )),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _importProducts,
                    icon: _isImporting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff4c345)),
                            ),
                          )
                        : const Icon(
                            Icons.upload_file,
                            color: Color(0xfff4c345),
                            size: 20,
                          ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addProduct,
                    icon: const Icon(
                      Icons.add_circle_outline, 
                      color: Color(0xfff4c345),
                      size: 20,
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isSearching ? Icons.close : Icons.search,
                key: ValueKey<bool>(_isSearching),
                color: Colors.black87,
              ),
            ),
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearching ? 64 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isSearching ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (fetchedProducts) {
                products = fetchedProducts;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showAddProducts 
                      ? _buildAvailableProductsGrid()
                      : _buildProductList(),
                );
              },
              error: (error, stackTrace) => Center(child: Text("Error: $error")),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff4c345)),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showAddProducts = !_showAddProducts;
            });
          },
          backgroundColor: const Color(0xfff4c345),
          elevation: 4,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              _showAddProducts ? Icons.close : Icons.add,
              key: ValueKey<bool>(_showAddProducts),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final displayProducts = _searchResults.isEmpty && _searchController.text.isEmpty
        ? products
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
  
  Widget _buildAvailableProductsGrid() {
    final inventoryAsync = ref.watch(getInventoryProvider);

    return inventoryAsync.when(
      data: (availableProducts) {
        filteredProducts = _searchController.text.isEmpty
            ? availableProducts
            : availableProducts.where((product) =>
                product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                (product.description?.toLowerCase() ?? "").contains(_searchController.text.toLowerCase())
              ).toList();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchController.text.isEmpty
                      ? 'No products available'
                      : 'No products found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff4c345),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add New Product'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return _buildAvailableProductCard(product);
          },
        );
      },
      error: (error, stackTrace) => Center(
        child: Text('Error loading products: $error'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
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

  void _searchProducts() {
    setState(() {
      _searchResults = products
          .where((product) =>
              product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              (product.description?.toLowerCase() ?? "").contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Widget _buildAvailableProductCard(ProductInventory product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: () => _addExistingProduct(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    Image.network(
                      product.imageUrl!,
                      height: 140,
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
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xfff4c345),
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
                    )
                  else
                    Container(
                      height: 140,
                      color: Colors.grey[100],
                      child: const Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 50,
                          color: Color(0xfff4c345),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xfff4c345),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description ?? 'No description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '0/${product.units}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xfff4c345),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
