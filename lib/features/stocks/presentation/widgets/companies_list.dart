import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/company_card.dart';

class CompaniesList extends StatelessWidget {
  final List<Company> companies;

  const CompaniesList({
    required this.companies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: companies.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 300),
          child: SlideAnimation(
            horizontalOffset: 150.0,
            child: FadeInAnimation(
              child: CompanyCard(
                company: companies[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
