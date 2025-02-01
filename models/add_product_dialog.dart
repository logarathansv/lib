import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'product.dart';

class AddProductDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onProductAdded;

  const AddProductDialog({
    super.key,
    this.product,
    required this.onProductAdded,
  });

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  File? selectedImage;

  bool isNameValid = true;
  bool isDescriptionValid = true;
  bool isPriceValid = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add New Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    selectedImage = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
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
                errorText:
                    isDescriptionValid ? null : 'Description is required',
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
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              isNameValid = nameController.text.isNotEmpty;
              isDescriptionValid = descriptionController.text.isNotEmpty;
              isPriceValid = priceController.text.isNotEmpty;
            });

            if (isNameValid && isDescriptionValid && isPriceValid) {
              widget.onProductAdded(Product(
                name: nameController.text,
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                quantity: int.tryParse(quantityController.text) ?? 0,
                imageUrl: selectedImage?.path ??
                    'https://via.placeholder.com/300x200',
              ));
              Navigator.of(context).pop();
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
          },
          child:
              Text(widget.product == null ? 'Add Product' : 'Update Product'),
        ),
      ],
    );
  }
}
