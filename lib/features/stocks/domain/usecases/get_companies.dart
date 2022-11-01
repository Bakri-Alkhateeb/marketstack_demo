import 'package:marketstack_demo/core/errors/failures.dart';
import 'package:marketstack_demo/core/usecases/usecase.dart';
import 'package:marketstack_demo/core/utils/typedefs.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/domain/repositories/stock_repo.dart';

class GetCompaniesUsecase
    extends UseCase<List<Company>, NoParams, StockFailure> {
  final StockRepo stockRepo;

  GetCompaniesUsecase({
    required this.stockRepo,
  });

  @override
  FunctionalFuture<StockFailure, List<Company>> call(NoParams params) async {
    return stockRepo.getCompanies();
  }
}
