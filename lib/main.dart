import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketstack_demo/app_router.dart';
import 'package:marketstack_demo/features/stocks/presentation/bloc/stock_bloc.dart';
import 'package:marketstack_demo/marketstack_demo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initApp();
}

void _initApp() {
  final AppRouter appRouter = AppRouter();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: _providers(),
        child: MarketStackDemoApp(
          appRouter: appRouter,
        ),
      ),
    ),
  );
}

List<BlocProvider> _providers() {
  return [
    BlocProvider<StockBloc>.value(
      value: StockBloc(),
      key: UniqueKey(),
    ),
  ];
}
