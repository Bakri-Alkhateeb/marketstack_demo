import 'package:flutter/material.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> addSizedBox({
    double? height,
  }) {
    return map(
      (item) => Column(
        children: [
          item,
          SizedBox(
            height: height ?? 20,
          )
        ],
      ),
    ).toList();
  }
}

extension ConvertToURL on DateTime {
  String convertToUrl() {
    late final String stringMonth;
    late final String stringDay;

    if (month < 10) {
      stringMonth = '0$month';
    } else {
      stringMonth = '$month';
    }

    if (day < 10) {
      stringDay = '0$day';
    } else {
      stringDay = '$day';
    }

    return "$year-$stringMonth-$stringDay";
  }
}
