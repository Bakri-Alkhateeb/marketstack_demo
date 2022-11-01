import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:marketstack_demo/core/enums/enums.dart';
import 'package:marketstack_demo/core/widgets/custom_card.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/stock.dart';
import 'package:marketstack_demo/features/stocks/presentation/bloc/stock_bloc.dart';

class ChartWidget extends StatefulWidget {
  final ChartDataPeriod period;
  final String stockName;

  const ChartWidget({
    required this.period,
    required this.stockName,
    super.key,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late final StockBloc _stockBloc;
  late List<FlSpot> _values;
  final List<Stock> _stocks = [];
  final DateTime dateTo = DateTime.now();
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  final int _divider = 25, _leftLabelsCount = 6;
  bool _firstTime = true, _isLoading = true;
  double _minX = 0, _maxX = 0, _minY = 0, _maxY = 0, _leftTitlesInterval = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _stockBloc = BlocProvider.of<StockBloc>(context);

      final DateTime? dateFrom = _initDateFrom();

      _stockBloc.add(
        GetStocks(
          symbol: widget.stockName,
          dateTo: dateTo,
          dateFrom: dateFrom,
        ),
      );

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockBloc, StockState>(
      listener: _stocksListener,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomCard(
              onTap: null,
              cardColor: const Color(0xff37434d),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: LineChart(
                  _mainData(),
                ),
              ),
            ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    String text = intl.NumberFormat.compactCurrency(symbol: '\$').format(value);

    return FittedBox(
      child: Text(
        text,
        style: style,
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _flGridData(),
      titlesData: _flTitlesData(),
      borderData: _flBorderData(),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        _lineChartBarData(),
      ],
    );
  }

  FlGridData _flGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 20,
      verticalInterval: 20,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.white,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _flTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: _leftTitlesInterval,
          getTitlesWidget: _leftTitleWidgets,
          reservedSize: 24,
        ),
      ),
    );
  }

  FlBorderData _flBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
    );
  }

  LineChartBarData _lineChartBarData() {
    return LineChartBarData(
      spots: _stocks
          .map(
            (stock) => FlSpot(
              stock.date.millisecondsSinceEpoch.toDouble(),
              stock.close,
            ),
          )
          .toList(),
      isCurved: true,
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: gradientColors
              .map(
                (color) => color.withOpacity(0.3),
              )
              .toList(),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  DateTime? _initDateFrom() {
    late final DateTime? dateFrom;

    switch (widget.period) {
      case ChartDataPeriod.oneDay:
        dateFrom = dateTo.subtract(
          const Duration(days: 1),
        );
        break;
      case ChartDataPeriod.fiveDays:
        dateFrom = dateTo.subtract(
          const Duration(days: 5),
        );
        break;
      case ChartDataPeriod.oneMonth:
        dateFrom = dateTo.subtract(
          const Duration(days: 30),
        );
        break;
      case ChartDataPeriod.oneYear:
        dateFrom = dateTo.subtract(
          const Duration(days: 365),
        );
        break;
      case ChartDataPeriod.fiveYears:
        dateFrom = dateTo.subtract(
          const Duration(days: 365 * 5),
        );
        break;
      case ChartDataPeriod.all:
        dateFrom = null;
        break;
    }

    return dateFrom;
  }

  void _prepareStockData() async {
    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _values = _stocks.map((stock) {
      if (minY > stock.close) {
        minY = stock.close;
      }

      if (maxY < stock.close) {
        maxY = stock.close;
      }

      return FlSpot(
        stock.date.millisecondsSinceEpoch.toDouble(),
        stock.close,
      );
    }).toList();

    _minX = _values.first.x;
    _maxX = _values.last.x;

    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;

    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();
  }

  void _stocksListener(context, state) {
    /// StocksLoading
    if (state is StocksLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    /// StocksLoaded
    else if (state is StocksLoaded) {
      setState(() {
        _stocks.clear();
        _stocks.addAll(state.stocks);
        _prepareStockData();
        _isLoading = false;
      });
    }

    /// StocksError
    else if (state is StocksError) {
      setState(() {
        _stocks.clear();
        _isLoading = false;
      });
    }
  }
}
