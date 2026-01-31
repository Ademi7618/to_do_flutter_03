import 'package:drift/drift.dart' show Value;
import 'package:to_do_flutter_03/database/app_databese.dart';


abstract class TodoRepository {
  Future<List<Todo>> fetchList();
  Future<int> addTodo({
    required String title,
    required String date,
    String? description,
  });
  Future<int> updateTodo({
    required int id,
    String? title,
    String? description,
    bool? isFinished,
    String? date,
  });
  Future<int> deleteTodo({required int id});
}

class TodoRepositoryImpl implements TodoRepository {
  final AppDatabase db;

  TodoRepositoryImpl(this.db);

  @override
  Future<int> addTodo({
    required String title,
    required String date,
    String? description,
  }) => db.insertTodo(
    TodosCompanion.insert(
      title: title,
      date: date,
      description: Value(description),
    ),
  );

  @override
  Future<List<Todo>> fetchList() => db.getTodoList();

  @override
  Future<int> updateTodo({
    required int id,
    String? title,
    String? description,
    bool? isFinished,
    String? date,
  }) {
    return db.updateTodo(
      id,
      TodosCompanion(
        title: title == null ? const Value.absent() : Value(title),
        description: description == null
            ? const Value.absent()
            : Value(description),
        isCompleted: isFinished == null
            ? const Value.absent()
            : Value(isFinished),
        date: date == null ? const Value.absent() : Value(date),
      ),
    );
  }

  @override
  Future<int> deleteTodo({required int id}) => db.deleteTodo(id);
}
