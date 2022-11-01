import 'package:equatable/equatable.dart';
import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/usecases/usecase.dart';
import 'package:marketstack_demo/core/utils/typedefs.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';
import 'package:marketstack_demo/features/stocks/domain/repositories/stock_repo.dart';

class GetStocksUsecase
    extends UseCase<List<Stock>, StocksParams, StockFailure> {
  final StockRepo stockRepo;

  GetStocksUsecase({
    required this.stockRepo,
  });

  @override
  FunctionalFuture<StockFailure, List<Stock>> call(StocksParams params) async {
    return stockRepo.getStocks(
      symbol: params.symbol,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
    );
  }
}

class StocksParams extends Equatable {
  final String symbol;
  final DateTime? dateFrom, dateTo;

  const StocksParams({
    required this.symbol,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [dateTo, dateFrom];
}
