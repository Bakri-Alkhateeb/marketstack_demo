import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketstack_demo/core/enums/enums.dart';
import 'package:marketstack_demo/core/functions/functions.dart';
import 'package:marketstack_demo/core/widgets/custom_card.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/presentation/bloc/stock_bloc.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/chart_widget.dart';

class CompanyStockDetailsScreen extends StatefulWidget {
  static const String routeName = '/CompanyStockDetailsScreen';
  const CompanyStockDetailsScreen({
    super.key,
  });

  @override
  State<CompanyStockDetailsScreen> createState() =>
      _CompanyStockDetailsScreenState();
}

class _CompanyStockDetailsScreenState extends State<CompanyStockDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final Company _company;
  late final TabController _tabController;
  bool _firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _tabController = TabController(
        length: 6,
        vsync: this,
      );

      Map<String, dynamic>? args = ModalRoute.of(
        context,
      )!
          .settings
          .arguments as Map<String, dynamic>?;

      _company = args!['company'];

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockBloc, StockState>(
      listener: _stocksListener,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomCard(
                child: _buildLogoAndName(),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTabBar(),
              const SizedBox(
                height: 20,
              ),
              _buildTabBarView(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          ChartWidget(
            period: ChartDataPeriod.oneDay,
            stockName: _company.stockName,
          ),
          ChartWidget(
            period: ChartDataPeriod.fiveDays,
            stockName: _company.stockName,
          ),
          ChartWidget(
            period: ChartDataPeriod.oneMonth,
            stockName: _company.stockName,
          ),
          ChartWidget(
            period: ChartDataPeriod.oneYear,
            stockName: _company.stockName,
          ),
          ChartWidget(
            period: ChartDataPeriod.fiveYears,
            stockName: _company.stockName,
          ),
          ChartWidget(
            period: ChartDataPeriod.all,
            stockName: _company.stockName,
          ),
        ],
      ),
    );
  }

  CustomCard _buildTabBar() {
    return CustomCard(
      onTap: null,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: FittedBox(
              child: Text(
                '1D',
                style: _tabTextStyle(),
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              child: Text(
                '5D',
                style: _tabTextStyle(),
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              child: Text(
                '1M',
                style: _tabTextStyle(),
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              child: Text(
                '1Y',
                style: _tabTextStyle(),
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              child: Text(
                '5Y',
                style: _tabTextStyle(),
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              child: Text(
                'All',
                style: _tabTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _tabTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 17,
    );
  }

  Row _buildLogoAndName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _company.stockName,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(_company.name),
    );
  }

  void _stocksListener(context, state) {
    if (state is StocksError) {
      snackBarMessage(
        context: context,
        message: state.error,
        backgroundColor: Colors.red,
      );
    }
  }
}
