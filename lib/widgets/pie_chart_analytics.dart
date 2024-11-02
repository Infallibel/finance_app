import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:finance_app/widgets/formatted_balance_text.dart';
import 'package:flutter/material.dart';

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
        child: Stack(
          children: [
            DChartPieO(
              data: ordinalDataList,
              configRenderPie: const ConfigRenderPie(
                strokeWidthPx: 0,
                arcWidth: 32,
              ),
            ),
            Center(
              child: FormattedBalanceText(
                balance: monthBalance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
