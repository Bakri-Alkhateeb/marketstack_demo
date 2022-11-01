import 'package:dartz/dartz.dart';
import 'package:marketstack_demo/core/errors/failures.dart';

typedef FunctionalFuture<F extends Failure, T> = Future<Either<F, T>>;
