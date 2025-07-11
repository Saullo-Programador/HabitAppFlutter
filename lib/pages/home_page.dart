import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:habitude_app/components/my_drawer.dart';
import 'package:habitude_app/components/my_habit_tile.dart';
import 'package:habitude_app/components/my_heat_map.dart';
import 'package:habitude_app/database/habit_database.dart';
import 'package:habitude_app/models/habit.dart';
import 'package:habitude_app/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late AnimationController _heatMapController;
  late Animation<double> _heatMapAnimation;

  @override
  void initState() {
    super.initState();
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    _heatMapController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _heatMapAnimation = CurvedAnimation(
      parent: _heatMapController,
      curve: Curves.easeIn,
    );

    // começa o fade do HeatMap ao abrir o app
    _heatMapController.forward();
  }

  @override
  void dispose() {
    _heatMapController.dispose();
    textController.dispose();
    super.dispose();
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitComppletion(habit.id, value);
    }
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Create a new Habit'),
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.primaryFixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            onPressed: () {
              if (textController.text != "") {
                String newHabitName = textController.text;
                context.read<HabitDatabase>().addHabit(newHabitName);
                Navigator.pop(context);
                textController.clear();
              }
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.primaryFixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deletHabitBox(Habit habit) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            onPressed: () {            
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home Page'), 
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          FadeTransition(
            opacity: _heatMapAnimation,
            child: _buildHeatMap(),
          ),
          Expanded(
            child: _buildAnimatedHabitList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildAnimatedHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: currentHabits.asMap().entries.map((entry) {
          int index = entry.key;
          Habit habit = entry.value;
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 100.0,
              child: FadeInAnimation(
                child: ListTile(
                  title: MyHabitTile(
                    text: habit.name,
                    isCompleted: isCompletedToday,
                    onChanged: (value) => checkHabitOnOff(value, habit),
                    editHabit: (context) => editHabitBox(habit),
                    deletHabit: (context) => deletHabitBox(habit),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
