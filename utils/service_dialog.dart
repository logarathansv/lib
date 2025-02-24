import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/service_provider.dart';
import '../models/service_model/service_model.dart';

class ServiceDialog extends ConsumerStatefulWidget{
  final Service? service;
  final Function(Service) onServiceAdded;
  final Function(Service) onServiceUpdated;

  const ServiceDialog({
    super.key,
    this.service,
    required this.onServiceAdded,
    required this.onServiceUpdated,
  });

  @override
  _ServiceDialogState createState() => _ServiceDialogState();
}

class _ServiceDialogState extends ConsumerState<ServiceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  File? selectedImage;
  String? existingImageUrl;

  bool isNameValid = true;
  bool isPriceValid = true;
  bool isDescriptionValid = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(text: widget.service?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.service?.description ?? '');

    if (widget.service != null) {
      existingImageUrl = widget.service!.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _handleSubmit() async {
    setState(() {
      isNameValid = _nameController.text.isNotEmpty;
      isDescriptionValid = _descriptionController.text.isNotEmpty;
      isPriceValid = _priceController.text.isNotEmpty;
    });

    if (isNameValid && isDescriptionValid && isPriceValid) {
      final newService = Service(
        Sid: widget.service?.Sid, // If updating, keep the same ID
        name: _nameController.text,
        description: _descriptionController.text,
        price: (_priceController.text),

      );

      try {
        if (widget.service == null) {
          print('Adding new Service');
          ref.watch(serviceServiceProvider).when(
            data: (serviceService) async {
              // Check if productService is the correct type
              try {
                await serviceService.addService(newService, selectedImage);
                widget.onServiceAdded(newService);
              } catch (e) {
                print(e);
              }
            },
            error: (error, stackTrace) {
              // Handle error
              print(error);
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
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
        }
        else{
          print('Updating Service');
          ref.watch(serviceServiceProvider).when(
            data: (serviceService) async {
              // Check if productService is the correct type
              try {
                await serviceService.editService(newService, selectedImage);
                widget.onServiceUpdated(newService);
              } catch (e) {
                print(e);
              }
            },
            error: (error, stackTrace) {
              // Handle error
              print(error);
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
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
        }
        ref.invalidate(getServicesProvider);
        Navigator.of(context).pop();
      }catch(e){
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
    }
    else{
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
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(widget.service==null ? 'Add New Service':'Edit Services'),
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
            const SizedBox(height: 12,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Service Name *',
                errorText: isNameValid? null:'Name is required',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Service Description *',
                errorText: isDescriptionValid? null:'Description is required',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Service Price *',
                errorText: isPriceValid? null:'Price is required',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions:[
        TextButton(
            onPressed: _handleSubmit,
            child: Text(widget.service==null? 'Add Service':'Edit Service'))
      ]
    );
  }
}