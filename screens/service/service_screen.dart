import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/service_model/service_model.dart';
import '../../providers/service_provider.dart';
import '../../utils/service_dialog.dart';
import '../../widgets/service_card.dart';

class ServicePage extends ConsumerStatefulWidget {
  final bool autoTriggerAddService;

  const ServicePage({super.key, this.autoTriggerAddService = false});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends ConsumerState<ServicePage> {
  List<Service> services = [];
  final _searchController = TextEditingController();
  List<Service> _searchResults = [];
  String _filterType = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getServices();
    });
  }
    void getServices() async{
      final servicesAsync = ref.watch(getServicesProvider);
      servicesAsync.when(
        data: (fetchedServices){
          setState(() {
            services=fetchedServices;
          });
        },
        error: (error,stackTrace){
          print("Error Loading services: $error");
          return [];
        },
        loading:
            ()=>CircularProgressIndicator(),
      );
    }

  void _addService() async {
    await showDialog(
      context: context,
      builder: (context) => ServiceDialog(
        onServiceAdded: (service) {
          ref.invalidate(getServicesProvider);
        },
        onServiceUpdated: (service) {},
      ),
    );
  }


  void _editService(Service service) async {
    await showDialog(
      context: context,
      builder: (context) => ServiceDialog(
        service: service,
        onServiceUpdated: (updatedService) {
          setState(() {
            // Instead of modifying the existing product, replace it in the list
            int index = services.indexWhere((p) => p.Sid == service.Sid);
            if (index != -1) {
              services[index] = Service(
                Sid: updatedService.Sid,
                name: updatedService.name,
                description: updatedService.description,
                price: updatedService.price,
                imageUrl: updatedService.imageUrl,// Ensure image is not lost
              );
            }
          });
          ref.invalidate(getServicesProvider);
        },
        onServiceAdded: (updatedService) {},
      ),
    );
  }


  void _deleteService(int index) async {
    final service = services[index];

    try {
      await ref.read(serviceServiceProvider.future).then((serviceService) {
        return serviceService.deleteService(service.Sid!);
      });

      ref.invalidate(getServicesProvider); // Ensure list is reloaded

      setState(() {
        services.removeAt(index); // Remove service after deletion
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${service.name} deleted successfully')),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to delete Service: $e'),
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
    final productsAsync = ref.watch(getServicesProvider);

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
          'Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: productsAsync.when(
        data: (fetchedServices) {
          services = fetchedServices; // Update the local services list
          return _buildServiceList();
        },
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildServiceList() {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search... ",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                      ),
                      onChanged: (text) => _searchProducts(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Filter Tags
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterTag('All'),
                        _buildFilterTag('Price: Low to High'),
                        _buildFilterTag('Price: High to Low'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.isEmpty
                    ? _getFilteredServices().length
                    : _searchResults.length,
                itemBuilder: (context, index) {
                  final service = _searchResults.isEmpty
                      ? _getFilteredServices()[index]
                      : _searchResults[index];
                  return ServiceCard(
                    service: service,
                    onEdit: () => _editService(service),
                    onDelete: () => _deleteService(index),
                  );
                },
              ),
            ),
          ],
        ),
        // Add Product Button
        Positioned(
          bottom: 25,
          right: 20,
          child: ElevatedButton(
            onPressed: _addService,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff4c345),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              minimumSize: const Size(40, 40),
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTag(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
          _filterType == label ? const Color(0xfff4c345) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _filterType == label ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Filter products based on the selected filter type
  List<Service> _getFilteredServices() {
    // return products;
    switch (_filterType) {
      case 'Price: Low to High':
        return List.from(services)..sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      case 'Price: High to Low':
        return List.from(services)..sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
      default:
        return services;
    }
  }

  void _searchProducts() {
    setState(() {
      _searchResults = services
          .where((service) =>
      service.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          (service.description?.toLowerCase() ?? "")
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }
}
