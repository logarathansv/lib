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
      'cost': (service['cost'] as num).toDouble(),  // Convert num to double
      'quantity': service['quantity'],
    })
        .toList();

    List<Map<String, dynamic>> productList = (json['Products'] as List)
        .map((product) => {
      'pname': product['pname'],
      'quantity': product['quantity'],
      'cost': (product['cost'] as num).toDouble(),  // Convert num to double
      'units': product['units'],
    })
        .toList();

    List<Map<String, dynamic>>? addressList = json['addresses'] as List<Map<String, dynamic>>?;
    String allCities = addressList == null || addressList.isEmpty
        ? ''
        : addressList.map((item) => item['city'] as String).join(', ');

    // Fix: Ensure 'cost' values are treated as num before converting to double
    double servicesTotal = serviceList.fold(0.0, (sum, item) => sum + (item['cost'] as num).toDouble());
    double productsTotal = productList.fold(0.0, (sum, item) => sum + (item['cost'] as num).toDouble());
    double totalAmount = servicesTotal + productsTotal;

    return Order(
      orderId: json['Oid'] as String,
      orderDate: json['Odate'] as String,
      services: serviceList,
      products: productList,
      customerId: json['customer']['CustId'] as String,
      customerName: json['customer']['Name'] as String,
      customerMobile: json['customer']['MobileNo'] as String,
      customerAddress: json['customer']['address'] as String,
      customerEmail: json['customer']['email'] as String,
      customerCreatedAt: json['customer']['created_at'] as String,
      totalAmount: totalAmount.toString(),
      shopName: json['businessClient']['shopname'] as String,
      shopAddress: allCities,
      shopPhoneNumber: json['businessClient']['shopmobile'] as String,
      shopEmail: json['businessClient']['shopemail'] as String,
    );
  }

}

class CreateOrder{

   String customerId;
   List<Map<String, dynamic>>? services;
   List<Map<String, dynamic>>? products;

  CreateOrder({
  required this.customerId,
  this.services,
  this.products
  });

  Map<String, dynamic> toJson() {
    return {
    "custid": customerId.toString(),
    "services": services!,
    "products": products!,
    };
  }
}
