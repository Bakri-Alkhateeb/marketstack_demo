import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/utils/typedefs.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';

abstract class StockRepo {
  FunctionalFuture<StockFailure, List<Stock>> getStocks({
    required String symbol,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  FunctionalFuture<StockFailure, List<Company>> getCompanies();
}
