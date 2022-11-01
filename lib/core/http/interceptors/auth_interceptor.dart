import 'dart:math';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:marketstack_demo/core/constants/constants.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({
    required RequestData data,
  }) async {
    data.params['access_key'] = apiKey;

    if (data.params['shouldLimit'] != null) {
      data.params.remove('shouldLimit');

      final Random random = Random();
      final int limit = 10, offset = random.nextInt(193904);

      data.params['offset'] = offset;
      data.params['limit'] = limit;
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({
    required ResponseData data,
  }) async {
    return data;
  }
}
