import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sklyit_business/providers/product_provider.dart';

import '../models/product_model/product_model.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  final Product? product;
  final Function(Product) onProductAdded;
  final Function(Product) onProductUpdated;

  const AddProductDialog({
    super.key,
    this.product,
    required this.onProductAdded,
    required this.onProductUpdated,
  });

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
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

  // Common product units
  final List<String> productUnits = [
    'kg', 'g', 'mg', 'L', 'ml', 
    'pcs', 'doz', 'pack', 'box', 'm', 
    'cm', 'mm', 'ft', 'yd', 'lb', 'oz'
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    descriptionController = TextEditingController(text: widget.product?.description ?? '');
    priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '');
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
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

      final newProduct = Product(
        id: widget.product?.id,  // If updating, keep the same ID
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        quantity: quantityController.text,
        imageUrl: existingImageUrl, // Preserve existing image URL if no new image is selected
        units: unitsController.text,
      );

      try {
        if (widget.product == null) {
          // ADD NEW PRODUCT
          await ref.read(productApiProvider.future).then((productService) async {
            try {
              await productService.addProduct(newProduct, selectedImage);
              widget.onProductAdded(newProduct);
              Navigator.of(context).pop();
            } catch (e) {
              print('Error adding product: $e');
              _showErrorDialog('Failed to add product: $e');
            }
          });
        } else {
          // UPDATE EXISTING PRODUCT
          await ref.read(productApiProvider.future).then((productService) async {
            try {
              await productService.updateProduct(newProduct, selectedImage);
              widget.onProductUpdated(newProduct);
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
        borderRadius: BorderRadius.circular(16),
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
              decoration: BoxDecoration(
                color: const Color(0xfff4c345),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product == null ? 'Add New Product' : 'Edit Product',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
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
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : existingImageUrl != null && existingImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        existingImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Add Image',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Form Fields
                    _buildTextField(
                      controller: nameController,
                      label: 'Product Name',
                      errorText: isNameValid ? null : 'Name is required',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined, size: 20),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildTextField(
                      controller: descriptionController,
                      label: 'Description',
                      errorText: isDescriptionValid ? null : 'Description is required',
                      maxLines: 2,
                      prefixIcon: const Icon(Icons.description_outlined, size: 20),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: priceController,
                            label: 'Price',
                            errorText: isPriceValid ? null : 'Price is required',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: quantityController,
                            label: 'Quantity',
                            errorText: isQuantityValid ? null : 'Quantity is required',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.inventory_2_outlined, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Units Dropdown
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Units',
                        errorText: isUnitsValid ? null : 'Please select unit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        prefixIcon: const Icon(Icons.scale_outlined, size: 20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: unitsController.text.isEmpty ? null : unitsController.text,
                          isExpanded: true,
                          hint: const Text('Select unit'),
                          items: productUnits.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                _getUnitLabel(unit),
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
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
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff4c345),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                            widget.product == null ? 'Add Product' : 'Update Product',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildTextField({
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
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        prefixIcon: prefixIcon,
      ),
      style: const TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  String _getUnitLabel(String unit) {
    switch (unit) {
      case 'kg':
        return 'Kilogram (kg)';
      case 'g':
        return 'Gram (g)';
      case 'mg':
        return 'Milligram (mg)';
      case 'L':
        return 'Liter (L)';
      case 'ml':
        return 'Milliliter (ml)';
      case 'pcs':
        return 'Pieces (pcs)';
      case 'doz':
        return 'Dozen (doz)';
      case 'pack':
        return 'Pack (pack)';
      case 'box':
        return 'Box (box)';
      case 'm':
        return 'Meter (m)';
      case 'cm':
        return 'Centimeter (cm)';
      case 'mm':
        return 'Millimeter (mm)';
      case 'ft':
        return 'Foot (ft)';
      case 'yd':
        return 'Yard (yd)';
      case 'lb':
        return 'Pound (lb)';
      case 'oz':
        return 'Ounce (oz)';
      default:
        return unit;
    }
  }
}