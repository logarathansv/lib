import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/product_provider.dart';

import '../models/product_model/product_model.dart';

class AddExistingProductDialog extends ConsumerStatefulWidget {
  final Product? product;
  final Function(Product) onProductAdded;
  final Function(Product) onProductUpdated;
  final bool flag;

  const AddExistingProductDialog({
    super.key,
    this.product,
    required this.onProductAdded,
    required this.onProductUpdated,
    required this.flag,
  });

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddExistingProductDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController unitsController;

  File? selectedImage;
  String? existingImageUrl;

  bool isNameValid = true;
  bool isDescriptionValid = true;
  bool isPriceValid = true;
  bool isQuantityValid = true;
  bool isUnitsValid = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    descriptionController = TextEditingController(text: widget.product?.description ?? '');
    priceController = TextEditingController(text: widget.product?.price ?? '');
    quantityController = TextEditingController(text: widget.product?.quantity ?? '');
    unitsController = TextEditingController(text: widget.product?.units ?? '');

    if (widget.product != null) {
      existingImageUrl = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    unitsController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      isNameValid = nameController.text.isNotEmpty;
      isDescriptionValid = descriptionController.text.isNotEmpty;
      isPriceValid = priceController.text.isNotEmpty;
      isQuantityValid = quantityController.text.isNotEmpty;
      isUnitsValid = unitsController.text.isNotEmpty;
    });

    if (isNameValid && isDescriptionValid && isPriceValid && isQuantityValid && isUnitsValid) {
      setState(() {
        isLoading = true;
      });

      final newProduct = {
        "productId": widget.product?.id,  // If updating, keep the same ID
        "price": priceController.text,
        "quantity": quantityController.text,
      };

      final product = Product(
        id: widget.product?.id,
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        quantity: quantityController.text,
        units: unitsController.text,
        isVerified: widget.product!.isVerified,
      );

      try {
        if(widget.flag == false){
          await ref.read(productApiProvider.future).then((productService) async {
            try {
              await productService.addBusinessProduct(newProduct);
              widget.onProductAdded(product);
              Navigator.of(context).pop();
            } catch (e) {
              print('Error adding product: $e');
              _showErrorDialog('Failed to add product: $e');
            }
          });
        }
        else {
          // UPDATE EXISTING PRODUCT
          await ref.read(productApiProvider.future).then((productService) async {
            try {
              newProduct.remove('productId'); // Remove productId from updat
              await productService.updateProduct(newProduct, widget.product!.id!);
              widget.onProductUpdated(product);
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating product: $e');
              _showErrorDialog('Failed to update product: $e');
            }
          });
        }
        ref.invalidate(getProductsProvider);
      } catch (e) {
        print('Error in product operation: $e');
        _showErrorDialog('Failed to process request: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      _showErrorDialog('Please fill in all mandatory fields.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product == null ? 'Add New Product' : 'Edit Product',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker
                    Center(
                      child: GestureDetector(
                        child: Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: existingImageUrl != null
                                ? Image.network(
                                    existingImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 32,
                                          color: Colors.black38,
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 32,
                                      color: Colors.black38,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Form Fields
                    buildTextField(
                      controller: nameController,
                      label: 'Product Name',
                      errorText: isNameValid ? null : 'Name is required',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    
                    buildTextField(
                      controller: descriptionController,
                      label: 'Description',
                      errorText: isDescriptionValid ? null : 'Description is required',
                      maxLines: 2,
                      prefixIcon: const Icon(Icons.description_outlined, size: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            controller: priceController,
                            label: 'Price',
                            errorText: isPriceValid ? null : 'Price is required',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.currency_rupee, size: 18, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            controller: quantityController,
                            label: 'Quantity',
                            errorText: isQuantityValid ? null : 'Quantity is required',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Units Dropdown
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Units',
                        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                        errorText: isUnitsValid ? null : 'Please select unit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        prefixIcon: const Icon(Icons.scale_outlined, size: 18, color: Colors.black54),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: unitsController.text.isEmpty ? null : unitsController.text,
                          isExpanded: true,
                          hint: const Text('Select unit', style: TextStyle(fontSize: 14)),
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          items: [DropdownMenuItem<String>(
                            value: widget.product?.units ?? '',
                            child: Text(
                              widget.product?.units ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          )],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                unitsController.text = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      foregroundColor: Colors.black54,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.flag == false ? 'Add Product' : 'Update Product',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget buildTextField({
  required TextEditingController controller,
  required String label,
  String? errorText,
  TextInputType? keyboardType,
  Widget? prefixIcon,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      prefixIcon: prefixIcon,
    ),
    style: const TextStyle(fontSize: 14, color: Colors.black87),
    keyboardType: keyboardType,
    maxLines: maxLines,
  );
}
}
