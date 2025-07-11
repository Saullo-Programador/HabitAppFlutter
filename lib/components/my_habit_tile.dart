import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deletHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deletHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            const SizedBox(width: 5),
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(10),
            ),
            // Adiciona um SizedBox para criar espaço entre os botões
            const SizedBox(width: 5), // Ajuste a largura conforme necessário
            SlidableAction(
              onPressed: deletHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
            ),
            
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          // item de hábito
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Theme.of(context).colorScheme.primaryFixed
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(9),
            ),
            padding: const EdgeInsets.all(5),
            child: ListTile(
              //texto
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted
                      ? Colors.white
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              
              // Checkbox
              leading: Checkbox(
                activeColor: Theme.of(context).colorScheme.primaryFixed,
                checkColor: Colors.white,
                value: isCompleted,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}