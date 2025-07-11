import 'package:flutter/material.dart';
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

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final TextEditingController textController = TextEditingController();

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
          //button to save
          MaterialButton(
            color: Theme.of(context).colorScheme.primaryFixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            onPressed: () {

              if (textController.text != ""){
                String newHabitName = textController.text;
                context.read<HabitDatabase>().addHabit(newHabitName);
                Navigator.pop(context);
                textController.clear();
              }
            },
            child: const Text('Save'),
          ),

          //button to cancel
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
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),

          //button to cancel
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
        title: Text("Are you sure you want to delete?"),
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

          //button to cancel
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
        child: const Icon(
          Icons.add, 
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildHeatMap(), // fica fixo
          Expanded(
            child: ListView(
              children: [
                _buildHabitList()
              ]
            ) , // só a lista rola
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap(){
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyHeatMap(
                  startDate: snapshot.data!,
                  datasets: prepHeatMapDataset(currentHabits),
                ),
              ),
            ],
          );
        }
        else{
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    // habit BD
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return ListTile(
          title: MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deletHabit: (context) => deletHabitBox(habit),
          ),
        );
      },
    );
  }
}
