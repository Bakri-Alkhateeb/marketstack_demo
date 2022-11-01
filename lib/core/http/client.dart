import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:marketstack_demo/core/http/interceptors/auth_interceptor.dart';

class Client {
  static http.Client client = InterceptedClient.build(
    interceptors: [
      AuthInterceptor(),
    ],
  );
}
