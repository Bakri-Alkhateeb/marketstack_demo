import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/services/network_service.dart';
import 'package:marketstack_demo/core/usecases/usecase.dart';
import 'package:marketstack_demo/features/stocks/data/repositories/stock_repo_impl.dart';
import 'package:marketstack_demo/features/stocks/data/sources/stock_remote_data_source.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';
import 'package:marketstack_demo/features/stocks/domain/repositories/stock_repo.dart';
import 'package:marketstack_demo/features/stocks/domain/usecases/get_companies.dart';
import 'package:marketstack_demo/features/stocks/domain/usecases/get_stocks.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepo stockRepo = StockRepoImpl(
    remoteDataSource: StockRemoteDataSourceImpl(
      networkService: NetworkServiceImpl(
        connectivity: Connectivity(),
      ),
    ),
  );

  StockBloc() : super(StockInitial()) {
    _getStocks();

    _getCompanies();
  }

  void _getStocks() async {
    on<GetStocks>((event, emit) async {
      emit(StocksLoading());

      final getStocks = GetStocksUsecase(
        stockRepo: stockRepo,
      );

      final result = await getStocks(
        StocksParams(
          symbol: event.symbol,
          dateTo: event.dateTo,
          dateFrom: event.dateFrom,
        ),
      );

      await emit.forEach(
        _foldGetStocks(result),
        onData: (StockState state) {
          return state;
        },
      );
    });
  }

  void _getCompanies() async {
    on<GetCompanies>((event, emit) async {
      emit(StocksLoading());

      final getCompanies = GetCompaniesUsecase(
        stockRepo: stockRepo,
      );

      final result = await getCompanies(
        NoParams(),
      );

      await emit.forEach(
        _foldGetCompanies(result),
        onData: (StockState state) {
          return state;
        },
      );
    });
  }

  Stream<StockState> _foldGetCompanies(
    Either<StockFailure, List<Company>> result,
  ) async* {
    yield result.fold(
      _stockFailure,
      (companies) {
        return CompaniesLoaded(
          companies: companies,
        );
      },
    );
  }

  Stream<StockState> _foldGetStocks(
    Either<StockFailure, List<Stock>> result,
  ) async* {
    yield result.fold(
      _stockFailure,
      (stocks) {
        return StocksLoaded(
          stocks: stocks,
        );
      },
    );
  }

  StockState _stockFailure(failure) {
    return StocksError(
      error: (failure as StockFailure).error,
    );
  }
}
