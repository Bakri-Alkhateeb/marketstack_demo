import 'dart:convert';

import 'package:marketstack_demo/core/errors/exceptions.dart';
import 'package:marketstack_demo/core/extensions/extensions.dart';
import 'package:marketstack_demo/core/functions/functions.dart';
import 'package:marketstack_demo/core/http/client.dart';
import 'package:marketstack_demo/core/services/network_service.dart';
import 'package:marketstack_demo/core/utils/server_info.dart';
import 'package:marketstack_demo/features/stocks/data/models/company_model.dart';
import 'package:marketstack_demo/features/stocks/data/models/stock_model.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';

abstract class StockRemoteDataSource {
  Future<List<Stock>> getStocks({
    required String symbol,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  Future<List<Company>> getCompanies();
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final NetworkService networkService;

  StockRemoteDataSourceImpl({
    required this.networkService,
  });

  @override
  Future<List<Stock>> getStocks({
    required String symbol,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    await _checkConnection();

    return await exceptionHandler<List<Stock>, StockException>(
      tryBlock: () async {
        String params = '?symbols=$symbol';

        if (dateFrom != null && dateTo != null) {
          params += "&date_from=${dateFrom.convertToUrl()}"
              "&date_to=${dateTo.convertToUrl()}";
        }

        final response = await Client.client.get(
          Uri.parse('${ServerInfo.eod}$params'),
        );

        final result = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final List<dynamic> stocksJson = result['data'];
          final List<Stock> stocks = [];

          for (final stockJson in stocksJson) {
            final Stock stock = StockModel.fromJson(stockJson);

            stocks.add(stock);
          }

          return stocks;
        } else {
          throw StockException(
            error: result['error']['message'],
          );
        }
      },
      makeException: StockException.new,
    );
  }

  @override
  Future<List<Company>> getCompanies() async {
    await _checkConnection();

    return await exceptionHandler<List<Company>, StockException>(
      tryBlock: () async {
        String params = '?shouldLimit=true';

        final response = await Client.client.get(
          Uri.parse('${ServerInfo.tickers}$params'),
        );

        final result = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final List<dynamic> companiesJson = result['data'];
          final List<Company> companies = [];

          for (final companyJson in companiesJson) {
            final Company company = CompanyModel.fromJson(companyJson);

            companies.add(company);
          }

          return companies;
        } else {
          throw StockException(
            error: result['error']['message'],
          );
        }
      },
      makeException: StockException.new,
    );
  }

  Future<void> _checkConnection() async {
    if (!(await networkService.isConnected)) {
      throw const StockException(
        error: 'You Are Not Connected To The Internet',
      );
    }
  }
}
