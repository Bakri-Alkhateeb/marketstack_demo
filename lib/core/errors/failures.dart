abstract class Failure {
  final String error;

  const Failure({
    required this.error,
  });
}

class StockFailure extends Failure {
  const StockFailure({
    required super.error,
  });
}
