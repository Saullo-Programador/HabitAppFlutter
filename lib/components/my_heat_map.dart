import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  
  final DateTime startDate;
  final Map<DateTime, int>? datasets;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets
  });

  @override
  Widget build(BuildContext context) {

    DateTime lastDayOfMonth = DateTime(startDate.year, startDate.month + 2, 0);

    return HeatMap(
      startDate: startDate,
      endDate: lastDayOfMonth,
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.tertiary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1: Colors.purple.shade400,
        2: Colors.purple.shade500,
        3: Colors.purple.shade600,
        4: Colors.purple.shade700,
        5: Colors.purple.shade800,
      },
    );
  }
}
