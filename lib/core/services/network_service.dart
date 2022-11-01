import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkService {
  Future<bool> get isConnected;
}

class NetworkServiceImpl implements NetworkService {
  final Connectivity connectivity;

  NetworkServiceImpl({
    required this.connectivity,
  });

  @override
  Future<bool> get isConnected async {
    ConnectivityResult result = await connectivity.checkConnectivity();

    if (result != ConnectivityResult.none) {
      return await _tryConnection();
    } else {
      return false;
    }
  }

  Future<bool> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup(
        'www.google.com',
        type: InternetAddressType.any,
      );

      return response.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
