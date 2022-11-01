import 'package:dartz/dartz.dart';
import 'package:marketstack_demo/core/errors/exceptions.dart';
import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/utils/typedefs.dart';
import 'package:marketstack_demo/features/stocks/data/sources/stock_remote_data_source.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';
import 'package:marketstack_demo/features/stocks/domain/repositories/stock_repo.dart';

class StockRepoImpl implements StockRepo {
  final StockRemoteDataSource remoteDataSource;

  const StockRepoImpl({
    required this.remoteDataSource,
  });

  @override
  FunctionalFuture<StockFailure, List<Stock>> getStocks({
    required String symbol,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final result = await remoteDataSource.getStocks(
        symbol: symbol,
        dateTo: dateTo,
        dateFrom: dateFrom,
      );

      return Right(result);
    } on StockException catch (e) {
      return Left(
        StockFailure(
          error: e.error,
        ),
      );
    }
  }

  @override
  FunctionalFuture<StockFailure, List<Company>> getCompanies() async {
    try {
      final result = await remoteDataSource.getCompanies();

      return Right(result);
    } on StockException catch (e) {
      return Left(
        StockFailure(
          error: e.error,
        ),
      );
    }
  }
}
