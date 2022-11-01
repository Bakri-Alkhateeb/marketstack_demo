class StockException implements Exception {
  final String error;

  const StockException({
    required this.error,
  });

  @override
  String toString() {
    return error;
  }
}
