import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class PieChartAnalytics extends StatelessWidget {
  const PieChartAnalytics({
    super.key,
    required this.monthBalance,
    required this.ordinalDataList,
  });

  final double monthBalance;
  final List<OrdinalData> ordinalDataList;

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
