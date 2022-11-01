import 'package:flutter/material.dart';
import 'package:marketstack_demo/features/stocks/presentation/pages/companies_screen.dart';
import 'package:marketstack_demo/features/stocks/presentation/pages/company_stock_details_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  Duration _duration() => const Duration(milliseconds: 300);

  PageTransition _pageTransition({
    required Widget child,
    required RouteSettings settings,
    PageTransitionType transitionType = PageTransitionType.rightToLeftWithFade,
  }) {
    return PageTransition(
      child: child,
      settings: settings,
      type: transitionType,
      duration: _duration(),
      reverseDuration: _duration(),
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CompanyStockDetailsScreen.routeName:
        return _pageTransition(
          child: const CompanyStockDetailsScreen(
            key: ValueKey('CompanyStockDetailsScreen'),
          ),
          settings: settings,
        );

      case CompaniesScreen.routeName:
      default:
        return _pageTransition(
          child: const CompaniesScreen(
            key: ValueKey('CompaniesScreen'),
          ),
          settings: settings,
          transitionType: PageTransitionType.fade,
        );
    }
  }
}
