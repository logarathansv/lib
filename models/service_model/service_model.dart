
class Service{
  String? Sid;
  final String name;
  final String? description;
  final String? imageUrl;
  final String price;

  Service({
    this.Sid,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      Sid: json['Sid'],
      name: json['ServiceName'],
      description: json['ServiceDesc'],
      imageUrl: json['ImageUrl'],
      price: json['ServiceCost'],
    );
  }
  //to json fuction
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'price': price,
  };
}