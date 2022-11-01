import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:marketstack_demo/core/functions/functions.dart';
import 'package:marketstack_demo/features/stocks/domain/entities/company.dart';
import 'package:marketstack_demo/features/stocks/presentation/bloc/stock_bloc.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/action_button.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/autocomplete_widget.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/companies_list.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/loading.dart';
import 'package:marketstack_demo/features/stocks/presentation/widgets/no_content.dart';

class CompaniesScreen extends StatefulWidget {
  static const String routeName = '/';

  const CompaniesScreen({
    super.key,
  });

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  late final StockBloc _stockBloc;
  final List<Company> _companies = [];
  bool _firstTime = true, _isLoading = true, _isSearching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _stockBloc = BlocProvider.of<StockBloc>(context);

      _stockBloc.add(
        GetCompanies(),
      );

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockBloc, StockState>(
      listener: _stocksListener,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _isLoading
            ? const Loading()
            : _companies.isEmpty
                ? const NoContent()
                : _buildContent(),
      ),
    );
  }

  Stack _buildContent() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: _isSearching ? 60 : 0),
          child: CompaniesList(
            companies: _companies,
          ),
        ),
        if (_isSearching)
          AutoCompleteWidget(
            companies: _companies,
            onBeforeSelected: () {
              setState(() {
                _isSearching = false;
              });
            },
          ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: const Text('Companies'),
      leading: ActionButton(
        onPressed: () {
          _stockBloc.add(
            GetCompanies(),
          );
        },
        icon: Ic.refresh,
      ),
      actions: [
        ActionButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
          icon: _isSearching ? Ic.close : Ic.search,
        ),
      ],
    );
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
        _isLoading = false;
      });
    }

    /// CompaniesLoaded
    else if (state is CompaniesLoaded) {
      setState(() {
        _companies.clear();
        _companies.addAll(state.companies);

        _isLoading = false;
      });
    }

    /// StocksError
    else if (state is StocksError) {
      setState(() {
        _isLoading = false;
      });

      snackBarMessage(
        context: context,
        message: state.error,
        backgroundColor: Colors.red,
      );
    }
  }
}
