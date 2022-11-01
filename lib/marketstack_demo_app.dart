import 'package:flutter/material.dart';
import 'package:marketstack_demo/app_router.dart';

class MarketStackDemoApp extends StatelessWidget {
  final AppRouter appRouter;

  const MarketStackDemoApp({
    required this.appRouter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarketStack Demo',
      onGenerateRoute: appRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
