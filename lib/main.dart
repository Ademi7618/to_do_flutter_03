import 'package:flutter/material.dart';
import 'package:to_do_flutter_03/database/app_databese.dart';
import 'package:to_do_flutter_03/home/home_Page.dart';
import 'package:to_do_flutter_03/to_do_Repository.dart';

late final AppDatabase database;
late final TodoRepository repository;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = AppDatabase();
  repository = TodoRepositoryImpl(database);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
