import 'package:flutter/material.dart';
import 'dart:io'; // For handling file images
import 'package:image_picker/image_picker.dart'; // For picking images from gallery

class ProductsSection extends StatefulWidget {
  final List<Map<String, dynamic>>
      products; // List of products passed from parent
  final bool isBusiness; // Boolean to check if the user is in business mode

  const ProductsSection({
    super.key,
    required this.products,
    required this.isBusiness,
  });

  @override
  _ProductsSectionState createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  @override
  Widget build(BuildContext context) {
    final popularProducts = widget.products
        .where((product) => product['isPopular'] == true)
        .toList();
    final otherProducts = widget.products
        .where((product) => product['isPopular'] != true)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHorizontalSection('Popular Products', popularProducts),
        const SizedBox(height: 20),
        _buildHorizontalSection('Our Products', otherProducts),
      ],
    );
  }

  // Handle adding a new product
  void _addProduct() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.products.add({
          'imageUrl': pickedFile.path, // Image path from the gallery
          'name': 'New Product', // Name of the product
          'description': 'Describe this product', // Product description
          'price': '0', // Price of the product
          'isPopular': false, // Default to non-popular
        });
      });
    }
  }

  void _editProduct(Map<String, dynamic> product) {
    // Controllers for editing fields
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price']);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental closing
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name Field
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true, // Automatically focus this input
                  ),
                  const SizedBox(height: 10),
                  // Description Field
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  // Price Field
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Numeric input
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog without saving
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Update product details
                    product['name'] = nameController.text;
                    product['description'] = descriptionController.text;
                    product['price'] = priceController.text;
                  });
                  Navigator.of(context).pop(); // Close dialog after saving
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Section Builder for Horizontal List
  Widget _buildHorizontalSection(
      String title, List<Map<String, dynamic>> productList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row with title and Add Button for 'Our Products' only
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (title == 'Our Products' && widget.isBusiness)
              IconButton(
                onPressed: _addProduct,
                icon: const Icon(Icons.add_circle),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300, // Constrain height of the horizontal ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  // Three dot menu for each card
  Widget _threeDotMenu(BuildContext context, Map<String, dynamic> product) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') {
          _editProduct(product);
        } else if (value == 'Delete') {
          setState(() {
            widget.products.remove(product);
          });
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: 'Edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem<String>(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  // Product Card Builder
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: product['imageUrl'].startsWith('http')
                      ? Image.network(
                          product['imageUrl'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(product['imageUrl']),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                const Spacer(), // Pushes content above this point upward

                // Row for Price and Buy Now Button
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0), // Ensures consistent spacing
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          product['price'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(), // Pushes button to the far right
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add Buying logic here
                          },
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Positioned Three-dot Menu at the Top-Right Corner
            if (widget.isBusiness && !(product['isPopular'] ?? false))
              Positioned(
                top: 8,
                right: 8,
                child: _threeDotMenu(context, product),
              ),
          ],
        ),
      ),
    );
  }
}
