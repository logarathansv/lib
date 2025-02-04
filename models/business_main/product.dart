class Product {
  String id;
  String name;
  String description;
  double price;
  int quantity;
  String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
  factory Product.fromJson(Map<String,dynamic> json){
    return Product(
      id: json['PId'] as String,
      name:json['Pname'] as String,
      description: json['Pdesc'] as String,
      price: json['Pprice'] as double,
      quantity: json['Pqty'] as int,
      imageUrl: json['PimageUrl'] as String
    );
  }

}
