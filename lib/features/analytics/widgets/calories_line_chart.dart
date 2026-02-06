import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CaloriesLineChart extends StatelessWidget {
  final List<int> values;
  final List<String> labels;
  final Color lineColor;

  const CaloriesLineChart({
    super.key,
    required this.values,
    required this.labels,
    required this.lineColor,
  }) : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty || labels.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('No data')),
      );
    }

    final maxValue = values.isEmpty
        ? 0
        : values.reduce((a, b) => a > b ? a : b).toDouble();
    final chartMax = maxValue == 0 ? 1.0 : maxValue * 1.2;
    final maxX =
        values.length > 1 ? (values.length - 1).toDouble() : 0.0;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: 0,
          maxY: chartMax,
          gridData: FlGridData(
            show: true,
            horizontalInterval: chartMax / 4,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: chartMax / 2,
                reservedSize: 36,
                getTitlesWidget: (value, meta) =>
                    Text(value.round().toString(),
                        style: const TextStyle(fontSize: 10)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(labels[index],
                        style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i].toDouble()),
              ],
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withAlpha(40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
