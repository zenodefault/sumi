import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MacroPieChart extends StatelessWidget {
  final double carbs;
  final double protein;
  final double fat;
  final List<Color> colors;

  const MacroPieChart({
    super.key,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final total = carbs + protein + fat;
    if (total <= 0) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text('No macro data yet'),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 24,
          sections: [
            PieChartSectionData(
              value: carbs,
              color: colors[0],
              title: '',
              radius: 50,
            ),
            PieChartSectionData(
              value: protein,
              color: colors[1],
              title: '',
              radius: 50,
            ),
            PieChartSectionData(
              value: fat,
              color: colors[2],
              title: '',
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}
