import 'package:flutter/material.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/presentation/pages/company_stock_details_screen.dart';

class AutoCompleteWidget extends StatelessWidget {
  final List<Company> companies;
  final VoidCallback onBeforeSelected;

  const AutoCompleteWidget({
    required this.companies,
    required this.onBeforeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Company>(
      optionsBuilder: (value) {
        if (value.text == '') {
          return companies;
        }

        return companies.where(
          (company) => company.name.toLowerCase().startsWith(
                value.text.toLowerCase(),
              ),
        );
      },
      displayStringForOption: (company) => company.name,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: TextFormField(
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            focusNode: focusNode,
            controller: textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "Search...",
            ),
          ),
        );
      },
      onSelected: (company) {
        onBeforeSelected();

        Navigator.of(context).pushNamed(
          CompanyStockDetailsScreen.routeName,
          arguments: {
            'company': company,
          },
        );
      },
    );
  }
}
