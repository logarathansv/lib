class Endpoints {
  static const String BASEURL = 'http://192.168.77.41:3000';

  static const String users = '/users';

  static const String login = '/bs/auth/login';
  static const String register = '/bs/auth/register';

  //Business Main Page
  static const String getPosts = '/bs/posts';
  static const String getServices = '/bs/services';
  static const String getProducts = '/bs/products';

  static const String refresh_token = '/bs/auth/refresh';

  //Notification
  static const String notification = '/notification';
  static const String notification_send = '/send';
  static const String notification_update = '/update_fcm_token';
  static const String message = '/messages';
}
