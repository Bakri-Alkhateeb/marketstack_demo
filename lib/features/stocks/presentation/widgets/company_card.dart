import 'package:flutter/material.dart';
import 'package:marketstack_demo/core/widgets/custom_card.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/presentation/pages/company_stock_details_screen.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({
    required this.company,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {
        Navigator.of(context).pushNamed(
          CompanyStockDetailsScreen.routeName,
          arguments: {
            'company': company,
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            company.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            company.stockName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
