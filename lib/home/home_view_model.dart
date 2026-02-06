import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_flutter_03/database/app_databese.dart';
import 'package:to_do_flutter_03/home/home_state.dart';
import 'package:to_do_flutter_03/to_do_Repository.dart';

class HomeViewModel {
  final TodoRepository repo;

  HomeViewModel({required this.repo});

  Future<List<Todo>> loadList() => repo.fetchList();

  Future<int> addTodo({
    required String title,
    required String date,
    String? description,
  }) {
    return repo.addTodo(title: title, date: date, description: description);
  }
}

class HomeCubit extends Cubit<HomeState> {
  final HomeViewModel vm;

  HomeCubit({required this.vm}) : super(HomeState.initial());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      //сначала ждем список потом выполняй следующее
      final items = await vm.loadList();
      //после получения данных только тогда фильтруем
      final filteredItems = _filterByDate(items);
      //после получения данных меняем state на то что данные имеются и отдаем список
      emit(state.copyWith(isLoading: false, items: filteredItems));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  List<Todo> _filterByDate(List<Todo> items) {
    return [...items]..sort((a, b) => b.date.compareTo(a.date));
  }
 
  Future<Todo?> createAndGetNew() async {
    final id = await vm.addTodo(
      title: "",
      date: DateTime.now().toString(),
      description: "",
    );
    final items = await vm.loadList();
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

class TodoException implements Exception {
  final String message;
  TodoException(this.message);
}
