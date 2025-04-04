class Order {
  String orderId;
  String orderDate;
  List<Map<String, dynamic>> services;
  List<Map<String, dynamic>> products;
  String customerId;
  String customerName;
  String customerMobile;
  String customerAddress;
  String customerEmail;
  String customerCreatedAt;
  String totalAmount;
  String shopName;
  String shopAddress;
  String shopPhoneNumber;
  String shopEmail;


  Order({
    required this.orderId,
    required this.orderDate,
    required this.services,
    required this.products,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerEmail,
    required this.customerCreatedAt,
    required this.totalAmount,
    required this.shopName,
    required this.shopAddress,
    required this.shopPhoneNumber,
    required this.shopEmail
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> serviceList = (json['Services'] as List)
        .map((service) => {
      'sname': service['sname'],
      'cost': double.parse(service['cost'].toString()),
      'quantity': int.parse(service['quantity'].toString()),
    })
        .toList();

    List<Map<String, dynamic>> productList = (json['Products'] as List)
        .map((product) => {
      'pname': product['pname'],
      'quantity': int.parse(product['quantity'].toString()),
      'cost': double.parse(product['cost'].toString()),
      'units': product['units'],
    })
        .toList();

    List<Map<String, dynamic>>? addressList = json['addresses'] as List<Map<String, dynamic>>?;
    String allCities = addressList == null || addressList.isEmpty
        ? ''
        : addressList.map((item) => item['city'] as String).join(', ');

    double servicesTotal = serviceList.fold(0.0, (sum, item) => sum + (item['cost'] as double));
    double productsTotal = productList.fold(0.0, (sum, item) => sum + (item['cost'] as double));
    double totalAmount = servicesTotal + productsTotal;

    return Order(
      orderId: json['Oid'].toString(),
      orderDate: json['Odate'].toString(),
      services: serviceList,
      products: productList,
      customerId: json['customer']['CustId'].toString(),
      customerName: json['customer']['Name'].toString(),
      customerMobile: json['customer']['MobileNo'].toString(),
      customerAddress: json['customer']['address'].toString(),
      customerEmail: json['customer']['email'].toString(),
      customerCreatedAt: json['customer']['created_at'].toString(),
      totalAmount: totalAmount.toString(),
      shopName: json['businessClient']['shopname'].toString(),
      shopAddress: allCities,
      shopPhoneNumber: json['businessClient']['shopmobile'].toString(),
      shopEmail: json['businessClient']['shopemail'].toString(),
    );
  }
}

class CreateOrder{

   String customerId;
   List<Map<String, dynamic>>? services;
   List<Map<String, dynamic>>? products;
   DateTime? orderDate = DateTime.now();
  CreateOrder({
  required this.customerId,
  this.services,
  this.products,
    this.orderDate
  });

  Map<String, dynamic> toJson() {
    return {
    "custid": customerId.toString(),
    "services": services!,
    "products": products!,
      "ODate": orderDate.toString(),
    };
  }
}
