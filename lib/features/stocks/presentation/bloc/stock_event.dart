part of 'stock_bloc.dart';

@immutable
abstract class StockEvent {
  const StockEvent();
}

class GetStocks extends StockEvent {
  final String symbol;
  final DateTime? dateTo, dateFrom;

  const GetStocks({
    required this.symbol,
    required this.dateTo,
    required this.dateFrom,
  });
}

class GetCompanies extends StockEvent {}
