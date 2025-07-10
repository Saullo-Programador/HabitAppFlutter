import 'package:flutter/cupertino.dart';
import 'package:habitude_app/models/app_settings.dart';
import 'package:habitude_app/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // inicializa o banco de dados
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  //Salva a data do primeiro lançamento
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Obtém a data do primeiro lançamento
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // Lista todos os hábitos
  final List<Habit> currentHabits = [];

  // C R E A T E
  Future<void> addHabit(String habitName) async {
    //cria um novo hábito
    final newHabit = Habit()..name = habitName;

    //salva no banco de dados
    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

  // R E A D
  Future<void> readHabits() async {
    //buscar todos os hábitos do banco de dados
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // dar aos hábitos atuais
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update the UI
    notifyListeners();
  }

  // U P D A T E
  Future<void> updateHabitComppletion(int id, bool isCompleted) async {
    // buscar o hábito pelo ID
    final habit = await isar.habits.get(id);

    // verificar se o hábito existe
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }

        await isar.habits.put(habit);
      });

      // atualizar a lista de hábitos
      readHabits();
    }
  }
  
  // U P D A T E N A M E
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // D E L E T E
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    readHabits();
  }
}
