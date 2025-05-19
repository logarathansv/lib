import 'package:flutter/material.dart';
import 'dart:io';

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
            _buildProductImage(product.imageUrl ?? ''),
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
              child: Text(product.description ?? '',
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