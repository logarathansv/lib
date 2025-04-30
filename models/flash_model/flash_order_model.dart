import 'package:sklyit_business/models/flash_model/flash_product.dart';

class FlashOrderModel {
  final String flashid;
  final String customerId;
  final String orderDate;
  final String totalAmount;
  final String customerName;
  final String customerMobile;
  final String customerAddress;
  final String customerEmail;
  final String orderId;
  final String shopName;
  final String shopAddress;
  final String shopPhoneNumber;
  final String shopEmail;
  final List<FlashProduct> products;
  
  FlashOrderModel({
    required this.flashid,
    required this.customerId,
    required this.orderDate,
    required this.totalAmount,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerEmail,
    required this.orderId,
    required this.shopName,
    required this.shopAddress,
    required this.shopPhoneNumber,
    required this.shopEmail,
    required this.products,
  });
}
