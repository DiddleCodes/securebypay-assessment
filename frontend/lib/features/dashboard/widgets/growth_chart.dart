import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/growth.dart';

class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key, required this.points});

  final List<GrowthPoint> points;

  static final _axisFormat = NumberFormat('#,##0', 'en_US');

  static const _leadingInset = 0.67;
  static const _trailingInset = 0.52;

  static double _niceInterval(int maxValue) {
    final raw = math.max(maxValue, 5) / 5;
    final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    for (final step in [1, 2, 2.5, 5, 10]) {
      if (step * magnitude >= raw) return step * magnitude;
    }
    return 10 * magnitude;
  }

  @override
  Widget build(BuildContext context) {
    final interval = _niceInterval(points.map((p) => p.value).fold(0, math.max));

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLabels = math.max(2, (constraints.maxWidth - 52) ~/ 48);
        final labelEvery = (points.length / maxLabels).ceil();
        return _chart(interval, labelEvery);
      },
    );
  }

  Widget _chart(double interval, int labelEvery) {
    return LineChart(
      duration: const Duration(milliseconds: 300),
      LineChartData(
        minX: -_leadingInset,
        maxX: points.length - 1 + _trailingInset,
        minY: 0,
        maxY: interval * 5,
        clipData: const FlClipData.horizontal(),
        borderData: FlBorderData(
          border: const Border(bottom: BorderSide(color: AppColors.chartGrid)),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          checkToShowHorizontalLine: (value) => value > 0,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.chartGrid, strokeWidth: 1, dashArray: [4, 4]),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: interval,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _axisFormat.format(value),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.chartAxis,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (value != index || index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                if (index % labelEvery != 0 && index != points.length - 1) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 10,
                  child: Text(points[index].label, style: AppTextStyles.chartAxis),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.navy,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                LineTooltipItem(
                  '${points[spot.x.round()].label}: ${_axisFormat.format(spot.y)}',
                  AppTextStyles.caption.copyWith(color: AppColors.onPrimary),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < points.length; i++)
                FlSpot(i.toDouble(), points[i].value.toDouble()),
            ],
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.14),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
