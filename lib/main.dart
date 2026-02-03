import 'package:flutter/material.dart';
import 'package:to_do_flutter_03/database/app_databese.dart';
import 'package:to_do_flutter_03/home/home_Page.dart';
import 'package:to_do_flutter_03/onboarding/onboarding_flow.dart';
import 'package:to_do_flutter_03/services/app_preferences.dart';
import 'package:to_do_flutter_03/to_do_Repository.dart';

late final AppDatabase database;
late final TodoRepository repository;
late final AppPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = AppDatabase();
  repository = TodoRepositoryImpl(database);
  preferences = AppPreferences.instance;
  await preferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seen = AppPreferences.instance.hasSeenOnboarding;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: seen ? MyHomePage(title: 'ToDo') : OnboardingFlow(),
    );
  }
}
