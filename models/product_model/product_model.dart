class Product {
  String? id;
  String name;
  String? description;
  String price;
  String quantity;
  String? imageUrl;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['PId'] ?? '', // Use null-aware operator to provide a default value
      name: json['Pname']?.toString() ?? '', // Use toString() to safely convert to string
      description: json['Pdesc']?.toString() ?? '',
      price: json['Pprice']?.toString() ?? '',
      quantity: json['Pqty']?.toString() ?? '',
      imageUrl: json['PimageUrl']?.toString() ?? '',
    );
  }

}