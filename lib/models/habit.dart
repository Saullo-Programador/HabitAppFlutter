import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit{
  //id Habito
  Id id = Isar.autoIncrement;

  //Nome do Habito
  late String name;

  //dias completados
  List<DateTime> completedDays = [
    //DataTime(ano, mes, dia)

  ];
}