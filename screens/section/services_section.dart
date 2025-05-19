import 'package:flutter/material.dart';
import 'dart:io'; // For handling file images
import 'package:sklyit_business/models/service_model/service_model.dart'; // For picking images from gallery

class ServicesSection extends StatefulWidget {
  final List<Service> services;
  final bool isBusiness;

  const ServicesSection(
      {super.key, required this.services, required this.isBusiness});

  @override
  _ServicesSectionState createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  // To simulate a list of services (you can replace it with actual data)
  final List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    final otherServices = widget.services.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildHorizontalSection('Our Services', otherServices),
      ],
    );
  }

  Widget _buildHorizontalSection(String title, List<Service> serviceList) {
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
            if (title == 'Our Services' && widget.isBusiness)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_circle),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300, // Constrain height of the horizontal ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final service = serviceList[index];
              return _buildServiceCard(service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Service service) {
    final imageUrl = service.imageUrl?.toString() ?? '';

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : imageUrl.isNotEmpty
                      ? Image.file(
                          File(imageUrl),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(
                          height: 150,
                          color: Colors.grey,
                          child: const Icon(Icons.image_not_supported),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                service.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                service.description?.toString() ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      service.price?.toString() ?? 'Free',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add booking logic here
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text('Book Now'),
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
}
