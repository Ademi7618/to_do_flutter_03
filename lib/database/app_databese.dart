import 'dart:io';
import 'todos.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_databese.g.dart';

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;
   @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(todos, todos.description);
          }
        },
      );

  Future<int> insertTodo(TodosCompanion todo) {
    return into(todos).insert(todo);
  }

  Future<List<Todo>> getTodoList() {
    return select(todos).get();
  }

  Future<int> updateTodo(int id, TodosCompanion date) {
    return (update(todos)..where((t) => t.id.equals(id))).write(date);
  }

  Future<int> deleteTodo(int id) {
    return (delete(todos)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}

// @DriftDatabase(tables: [Todos])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 2;

//  

//   //CREATE
//   Future<int> insertTodo(TodosCompanion todo) {
//    return into(todos).insert(todo);
//   }

//   //READ
//   Future<List<Todo>> getTodoList() {
//     return select(todos).get();
//   }

//   //UPDATE
//   Future<int> updateTodo(int id, TodosCompanion data) {
//     return (update(todos)..where((t) => t.id.equals(id))).write(data);
//   }

//   //DELETE
//   Future<int> deleteTodo(int id) {
//     return (delete(todos)..where((t) => t.id.equals(id))).go();
//   }

  
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'app.db'));
//     return NativeDatabase(file);
//   });
// }
