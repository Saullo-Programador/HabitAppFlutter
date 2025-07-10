import 'package:flutter/material.dart';
import 'package:habitude_app/database/habit_database.dart';
import 'package:habitude_app/pages/home_page.dart';
import 'package:habitude_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o HabitDatabase
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
