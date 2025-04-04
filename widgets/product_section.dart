import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/product_model/product_model.dart';

class ProductsSection extends StatefulWidget {
  final List<Product> products;
  final bool isBusiness;

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
    final otherProducts = widget.products
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildHorizontalSection('Our Products', otherProducts),
      ],
    );
  }

  // Add Product Functionality
  void _addProduct() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //
    // if (pickedFile != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => ProductDetailsScreen(
    //         imagePath: pickedFile.path,
    //         onSave: (newProduct) {
    //           setState(() {
    //             widget.products.add(newProduct);
    //           });
    //         },
    //       ),
    //     ),
    //   );
    // }
  }

  // Horizontal Section Builder
  Widget _buildHorizontalSection(
      String title, List<Product> productList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (title == 'Our Products' && widget.isBusiness)
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _addProduct,
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
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

  // Product Card Builder
  Widget _buildProductCard(Product product) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product.imageUrl!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(product.description!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ),
            const Spacer(),
            _buildPriceAndQuantity(product),
          ],
        ),
      ),
    );
  }

  // Product Image Widget
  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: imageUrl.startsWith('http')
          ? Image.network(imageUrl,
              height: 150, width: double.infinity, fit: BoxFit.cover)
          : Image.file(File(imageUrl),
              height: 150, width: double.infinity, fit: BoxFit.cover),
    );
  }

  // Price and Quantity Display
  Widget _buildPriceAndQuantity(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Row(
        children: [
          Text('₹${product.price}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('Qty: ${product.quantity}',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final String imagePath;
  final Function(Map<String, dynamic>) onSave;

  const ProductDetailsScreen(
      {super.key, required this.imagePath, required this.onSave});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String price = '';
  String quantity = '';

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
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.file(File(widget.imagePath),
                  height: 200, fit: BoxFit.cover),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Product Name', (value) => name = value),
                    const SizedBox(height: 10),
                    _buildTextField(
                        'Description', (value) => description = value,
                        maxLines: 3),
                    const SizedBox(height: 10),
                    _buildTextField('Price', (value) => price = value,
                        inputType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField('Quantity', (value) => quantity = value,
                        inputType: TextInputType.number),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          widget.onSave({
                            'imageUrl': widget.imagePath,
                            'name': name,
                            'description': description,
                            'price': price,
                            'quantity': int.tryParse(quantity) ?? 1,
                            'isPopular': false,
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSave,
      {int maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      maxLines: maxLines,
      keyboardType: inputType,
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
      onSaved: (value) => onSave(value!),
    );
  }
}
