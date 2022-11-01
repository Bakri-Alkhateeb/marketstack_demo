import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';

class StockModel extends Stock {
  StockModel({
    required super.date,
    required super.symbol,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      open: double.parse(json["open"].toString()),
      high: double.parse(json["high"].toString()),
      low: double.parse(json["low"].toString()),
      close: double.parse(json["close"].toString()),
      volume: double.parse(json["volume"].toString()),
      date: DateTime.parse(json["date"]),
      symbol: json["symbol"],
    );
  }
}
