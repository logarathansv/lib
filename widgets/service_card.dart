import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/service_model/service_model.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // Reduce overall width
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section (1/4th of the card width)
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(service.imageUrl ?? 'https://via.placeholder.com/300') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Details Section (3/4th of the card width)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Product Description
                    Text(
                      service.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Price and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${service.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 8),
                    // Edit and Delete Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: onEdit,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
