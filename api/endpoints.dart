class Endpoints {
  static const String BASEURL = 'http://192.168.255.85:3000';

  static const String users = '/users';

  static const String login = '/bs/auth/login';
  static const String register = '/users/register';
  static const String logout = '/bs/auth/logout';
  static const String register_business = '/bs/register';

  static const String check_domain = '/bs/domain';

  //Business Main Page
  static const String getPosts = '/bs/posts';
  static const String getServices = '/bs/services';
  // static const String getProducts = '/bs/products';

  static const String refresh_token = '/bs/auth/refresh';

  //Notification
  static const String notification = '/notification';
  static const String notification_send = '/send';
  static const String notification_update = '/update_fcm_token';
  static const String message = '/messages';

  //Inventory Management
  static const String getProducts='/bs/product';
  static const String editInventory='/bs/products';
  static const String deleteProduct='/bs/product';

  //Order Management
  static const String getOrders='/bs/orders';
  static const String editOrder='/bs/orders';
  static const String deleteOrder='/bs/orders';

  //Customer Management
  static const String getCustomers='/bs/bs_customer';
  static const String editCustomer='/bs/bs_customers';
  static const String deleteCustomer='/bs/bs_customer';
}
