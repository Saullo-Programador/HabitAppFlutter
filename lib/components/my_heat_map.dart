import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatefulWidget {
  final DateTime startDate;
  final Map<DateTime, int>? datasets;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  State<MyHeatMap> createState() => _MyHeatMapState();
}

class _MyHeatMapState extends State<MyHeatMap> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {

    
    DateTime lastDayOfMonth =
        DateTime(widget.startDate.year, widget.startDate.month + 2, 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HeatMap(
          startDate: widget.startDate,
          endDate: lastDayOfMonth,
          datasets: widget.datasets ?? {},
          colorMode: ColorMode.color,
          defaultColor: Theme.of(context).colorScheme.tertiary,
          textColor: Theme.of(context).colorScheme.inversePrimary,
          showColorTip: false,
          showText: false,
          scrollable: true,
          size: 30,
          colorsets: {
            1: Colors.purple.shade300,
            2: Colors.purple.shade400,
            3: Colors.purple.shade500,
            4: Colors.purple.shade600,
            5: Colors.purple.shade800,
          },
          onClick: (value) {
            setState(() {
              selectedDay = value;
            });
          },
        ),
        if (selectedDay != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 30),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _buildSelectedDayText(),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  String _buildSelectedDayText() {
    final habitsCount = widget.datasets?[selectedDay!] ?? 0;
    final date = selectedDay!;
    if (habitsCount != 0) {
      return "${date.day}/${date.month}/${date.year} "
          "($habitsCount hábitos)";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
