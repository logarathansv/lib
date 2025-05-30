class Product {
  final String? id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String units;
  final String price;
  final String quantity;
  final bool isVerified;
  final String? bpid;
  final String? busid;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.bpid,
    this.busid,
    required this.units,
    required this.price,
    required this.quantity,
    required this.isVerified,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      bpid: json['bpid'], // Assuming 'product' is the key for the product ma,
      id: json['product']['pid'],
      busid: json['businessClient']['BusinessId'],
      name: json['product']['pname'],
      description: json['product']['description'],
      imageUrl: json['product']['image_url'],
      units: json['product']['units'],
      price: json['price'].toString(),
      quantity: json['quantity'].toString(),
      isVerified: json['product']['is_verified'],
    );
  }
}

class ProductInventory {
  final String? id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String units;
  final String category;
  final String subCategory;
  final String? price;
  final String? quantity;
  final bool isVerified;

  ProductInventory({
    required this.name,
    this.id,
    this.description,
    this.imageUrl,
    this.price,
    this.quantity, // Add this field for the new lengt
    required this.units,
    required this.category,
    required this.subCategory,
    required this.isVerified,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      id: json['pid'],
      name: json['pname'],
      description: json['description'],
      imageUrl: json['image_url'],
      units: json['units'],
      category: json['category'],
      subCategory: json['sub_category'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': id,
      'pname': name,
      'description': description,
      'image_url': imageUrl,
      'units': units,
      'category': category,
      'sub_category': subCategory,
      'is_verified': isVerified,
    };
  }
}