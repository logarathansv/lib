import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sklyit_business/auth/auth_provider.dart';
import '../widgets/product_section.dart';
import 'customer_perspective.dart';
import '/services/services_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/business_provider.dart';
import '../api/service_service.dart';
import '../api/product_service.dart';
import '../api/post_service.dart';

class BusinessPerspective extends ConsumerStatefulWidget {
  const BusinessPerspective({super.key});

  @override
  _BusinessPerspectiveState createState() => _BusinessPerspectiveState();
}

class _BusinessPerspectiveState extends ConsumerState<BusinessPerspective> {
  final _formKey = GlobalKey<FormState>();
  String bannerImageUrl = '';
  bool showServices = true;
  bool showProducts = true;
  bool isLoading = true;
  bool isProcessing = false;

  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> allServices = [];
  List<Map<String, dynamic>> allProducts = [];

  // Initialize services with Dio client from provider
  late final ServiceService _serviceService;
  late final ProductService _productService;
  late final PostService _postService;

  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescController = TextEditingController();
  final TextEditingController _serviceCostController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productQtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authToken = ref.read(authTokenProvider);
    serviceApi = ServiceApi(authToken!);
    productApi = ProductApi(authToken);
    postApi = PostApi(authToken);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final services = await serviceApi.getServices();
      final products = await productApi.getProducts();
      final posts = await postApi.getPosts();

      setState(() {
        allServices = services?['services'] ?? [];
        allProducts = products ?? [];
        this.posts = posts ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  // Add a new service
  Future<void> _addService() async {
    final imageFile = await _pickImage();

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => isProcessing = true);
    try {
      final newService = await serviceApi.createService(
        _serviceNameController.text,
        _serviceDescController.text,
        _serviceCostController.text,
        imageFile,
      );
      setState(() {
        allServices.add(newService);
        _serviceNameController.clear();
        _serviceDescController.clear();
        _serviceCostController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add service: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Edit an existing service
  Future<void> _editService(int serviceId) async {
    setState(() => isProcessing = true);
    try {
      final updatedService = await serviceApi.editService(
        serviceId,
        _serviceNameController.text,
      );
      setState(() {
        final index = allServices.indexWhere((s) => s['Sid'] == serviceId);
        if (index != -1) {
          allServices[index] = updatedService;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit service: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Delete a service
  Future<void> _deleteService(int serviceId) async {
    setState(() => isProcessing = true);
    try {
      await serviceApi.deleteService(serviceId);
      setState(() {
        allServices.removeWhere((s) => s['Sid'] == serviceId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete service: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Add a new product
  Future<void> _addProduct() async {
    final imageFile = await _pickImage();

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => isProcessing = true);
    try {
      final newProduct = await productApi.createProduct(
        _productNameController.text,
        _productDescController.text,
        _productPriceController.text,
        _productQtyController.text,
        imageFile,
      );
      setState(() {
        allProducts.add(newProduct);
        _productNameController.clear();
        _productDescController.clear();
        _productPriceController.clear();
        _productQtyController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Edit an existing product
  Future<void> _editProduct(int productId) async {
    setState(() => isProcessing = true);
    try {
      final updatedProduct = await productApi.updateProduct(
        productId,
        _productNameController.text,
        _productDescController.text,
        _productPriceController.text,
        _productQtyController.text,
      );
      setState(() {
        final index = allProducts.indexWhere((p) => p['Pid'] == productId);
        if (index != -1) {
          allProducts[index] = updatedProduct;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit product: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Delete a product
  Future<void> _deleteProduct(int productId) async {
    setState(() => isProcessing = true);
    try {
      await productApi.deleteProduct(productId);
      setState(() {
        allProducts.removeWhere((p) => p['Pid'] == productId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // Add a new post
  Future<void> _addPost() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final newPost = await postApi.createPost(
          'New Post', // Replace with user input
          'Describe this post', // Replace with user input
          File(pickedFile.path),
        );
        setState(() {
          posts.add(newPost);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add post: $e')),
      );
    }
  }

  // Edit a post
  Future<void> _editPost(Map<String, dynamic> post) async {
    TextEditingController titleController =
        TextEditingController(text: post['title']);
    TextEditingController descriptionController =
        TextEditingController(text: post['description']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await postApi.updatePost(
                    post['_id'], // Assuming the post has an ID
                    titleController.text,
                    descriptionController.text,
                  );
                  setState(() {
                    post['title'] = titleController.text;
                    post['description'] = descriptionController.text;
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update post: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete a post
  Future<void> _deletePost(Map<String, dynamic> post) async {
    try {
      await postApi.deletePost(post['_id']); // Assuming the post has an ID
      setState(() {
        posts.remove(post);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  // Select banner image
  Future<void> _selectBannerImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          bannerImageUrl = pickedFile.path;
          ref
              .read(businessProvider.notifier)
              .updateBannerImageUrl(bannerImageUrl);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Pick an image
  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
    return null;
  }

  // Navigate to customer perspective
  void _viewAsCustomer() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final businessData = ref.read(businessProvider);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerPerspective(
            shopName: businessData.shopName,
            shopDescription: businessData.shopDescription,
            shopAddress: businessData.shopAddress,
            bannerImagePath: bannerImageUrl,
            services: showServices ? allServices : [],
            posts: posts,
            products: showProducts ? allProducts : [],
          ),
        ),
      );
    }
  }

  // Toggle buttons for services and products
  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text('Show Services'),
            Switch(
              value: showServices,
              onChanged: (value) {
                setState(() {
                  showServices = value;
                });
              },
            ),
          ],
        ),
        Column(
          children: [
            const Text('Show Products'),
            Switch(
              value: showProducts,
              onChanged: (value) {
                setState(() {
                  showProducts = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // Posts section
  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _addPost,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) => _buildPostCard(index),
          ),
        ),
      ],
    );
  }

  // Three-dot menu for posts
  Widget _threeDotMenu(BuildContext context, Map<String, dynamic> post) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') {
          _editPost(post);
        } else if (value == 'Delete') {
          _deletePost(post);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
        const PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.black),
    );
  }

  // Build a post card
  Widget _buildPostCard(int index) {
    final post = posts[index];
    final imageUrl = post['imageUrl'];
    final title = post['title'] ?? "Untitled";
    final description = post['description'] ?? "No Description";

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? (imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imageUrl),
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ))
                      : Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: Text('No Image')),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _threeDotMenu(context, post),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the business form
  Widget _buildBusinessForm() {
    final businessData = ref.watch(businessProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Shop Name'),
              initialValue: businessData.shopName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a shop name';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  ref.read(businessProvider.notifier).updateShopName(value);
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Shop Description'),
              initialValue: businessData.shopDescription,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a shop description';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  ref
                      .read(businessProvider.notifier)
                      .updateShopDescription(value);
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Shop Address'),
              initialValue: businessData.shopAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a shop address';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  ref.read(businessProvider.notifier).updateShopAddress(value);
                }
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectBannerImage,
              child: bannerImageUrl.isEmpty
                  ? Container(
                      height: 400,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('Tap to select banner image'),
                      ),
                    )
                  : Image.file(
                      File(bannerImageUrl),
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _viewAsCustomer,
                child: const Text('View as Customer'),
              ),
            ),
            const SizedBox(height: 20),
            _buildPostsSection(),
            const SizedBox(height: 20),
            _buildToggleButtons(),
            const SizedBox(height: 20),
            if (showServices) ...[
              ServicesSection(services: allServices, isBusiness: true),
            ],
            const SizedBox(height: 20),
            if (showProducts) ...[
              ProductsSection(products: allProducts, isBusiness: true),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Skly It ',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(47, 72, 88, 1),
                ),
              ),
              TextSpan(
                text: 'Professional ',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4C345),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBusinessForm(),
    );
  }
}
