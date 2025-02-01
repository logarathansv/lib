import 'package:flutter/material.dart';
import 'dart:io';

class BannerSection extends StatelessWidget {
  final String shopName;
  final String shopDescription;
  final String bannerImagePath;

  const BannerSection({
    super.key,
    required this.shopName,
    required this.shopDescription,
    required this.bannerImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.file(
          File(bannerImagePath),
          height: 300,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.network(
            'https://via.placeholder.com/300',
            height: 300,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                shopDescription,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
