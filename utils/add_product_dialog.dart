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

    if (isNameValid && isDescriptionValid && isPriceValid && isQuantityValid) {
      final newProduct = Product(
        id: widget.product?.id,  // If updating, keep the same ID
        name: nameController.text,
        description: descriptionController.text,
        price: (priceController.text),
        quantity: (quantityController.text),
        units: (unitsController.text),

      );

      try {
        print(widget.product);
        if (widget.product == null) {
          // ADD NEW PRODUCT
          print('Adding new product');
          ref.watch(productApiProvider).when(
            data: (productService) async {
              // Check if productService is the correct type
              try {
                await productService.addProduct(newProduct, selectedImage);
                widget.onProductAdded(newProduct);

              } catch (e) {
                print(e);
              }
              },
            error: (error, stackTrace) {
              // Handle error
              print(error);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to process request: $error'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              // Handle loading
              Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else {
          // UPDATE EXISTING PRODUCT
          ref.watch(productApiProvider).when(
            data: (productService) async {
              // Check if productService is the correct type
              try {
                await productService.updateProduct(newProduct, selectedImage);
                widget.onProductUpdated(newProduct);
              } catch (e) {
                print(e);
              }
              },
            error: (error, stackTrace) {
              // Handle error
              print('Error updating product: $error');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to update product: $error'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              // Handle loading
              Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        ref.invalidate(getProductsProvider);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to process request: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all mandatory fields.'),
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
    return AlertDialog(
      title: Text(widget.product == null ? 'Add New Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                    : existingImageUrl != null
                    ? Image.network(existingImageUrl!, fit: BoxFit.cover)
                    : const Center(child: Text('Tap to select image')),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Product Name *',
                errorText: isNameValid ? null : 'Name is required',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                errorText: isDescriptionValid ? null : 'Description is required',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price *',
                errorText: isPriceValid ? null : 'Price is required',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity *',
                errorText: isQuantityValid ? null : 'Quantity is required',
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: unitsController.text,
              decoration: InputDecoration(
                labelText: 'Units *',
                errorText: isUnitsValid ? null : 'Units is required',
              ),
              onChanged: (value) {
                unitsController.text = value!;
              },
              items: [
                DropdownMenuItem<String>(
                  value: '',
                  child: Text('Select Unit'),
                ),
                DropdownMenuItem<String>(
                  value: 'Kilogram (kg)',
                  child: Text('Kilogram (kg)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Litre (L)',
                  child: Text('Litre (L)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Gram (g)',
                  child: Text('Gram (g)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Millilitre (ml)',
                  child: Text('Millilitre (ml)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Piece (pcs)',
                  child: Text('Piece (pcs)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Dozen (dz)',
                  child: Text('Dozen (dz)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Packet (pkt)',
                  child: Text('Packet (pkt)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Metre (m)',
                  child: Text('Metre (m)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Foot (ft)',
                  child: Text('Foot (ft)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Milligram (mg)',
                  child: Text('Milligram (mg)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Box (bx)',
                  child: Text('Box (bx)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Quintal (qtl)',
                  child: Text('Quintal (qtl)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Tonne (ton)',
                  child: Text('Tonne (ton)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Centimetre (cm)',
                  child: Text('Centimetre (cm)'),
                ),
                DropdownMenuItem<String>(
                  value: 'Pav (250g)',
                  child: Text('Pav (250g)'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _handleSubmit,
          child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
        ),
      ],
    );
  }
}
