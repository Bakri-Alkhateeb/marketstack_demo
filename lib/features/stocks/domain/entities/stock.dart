class Stock {
  final double open, high, low, close, volume;
  final DateTime date;
  final String symbol;

  const Stock({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.date,
    required this.symbol,
  });
}
