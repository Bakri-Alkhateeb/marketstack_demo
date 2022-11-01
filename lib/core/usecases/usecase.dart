import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/utils/typedefs.dart';

abstract class UseCase<R, P, F extends Failure> {
  const UseCase();

  FunctionalFuture<F, R> call(P params);
}

class NoParams {}
