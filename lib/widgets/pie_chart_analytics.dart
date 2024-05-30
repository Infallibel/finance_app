import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class PieChartAnalytics extends StatelessWidget {
  PieChartAnalytics({super.key, required this.monthBalance});

  final double monthBalance;
  final List<OrdinalData> ordinalDataList = [
    OrdinalData(domain: 'Coffee', measure: 538.00, color: kColorBrown),
    OrdinalData(domain: 'Grocery', measure: 444.70, color: kColorRed),
    OrdinalData(domain: 'Taxi', measure: 358.63, color: kColorYellow),
    OrdinalData(domain: 'Health', measure: 25.12, color: kColorTurquoise),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AspectRatio(
        aspectRatio: 5 / 4,
        child: Stack(children: [
          DChartPieO(
            data: ordinalDataList,
            configRenderPie: const ConfigRenderPie(
              strokeWidthPx: 0,
              arcWidth: 32,
            ),
          ),
          Center(
            child: Text(
                monthBalance < 0
                    ? '- \$${monthBalance.abs().toStringAsFixed(2)}'
                    : '\$${monthBalance.toStringAsFixed(2)}',
                style: kFontStyleLato.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ]),
      ),
    );
  }
}
