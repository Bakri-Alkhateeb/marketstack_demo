import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';

class CompanyModel extends Company {
  CompanyModel({
    required super.name,
    required super.stockName,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json["name"].toString().toLowerCase() == 'null'
          ? json["symbol"]
          : json["name"],
      stockName: json["symbol"],
    );
  }
}
