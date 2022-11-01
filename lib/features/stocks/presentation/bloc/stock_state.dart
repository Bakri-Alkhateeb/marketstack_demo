part of 'stock_bloc.dart';

@immutable
abstract class StockState {
  const StockState();
}

class StockInitial extends StockState {}

class StocksLoading extends StockState {}

class StocksLoaded extends StockState {
  final List<Stock> stocks;

  const StocksLoaded({
    required this.stocks,
  });
}

class CompaniesLoaded extends StockState {
  final List<Company> companies;

  const CompaniesLoaded({
    required this.companies,
  });
}

class StocksError extends StockState {
  final String error;

  const StocksError({
    required this.error,
  });
}
