import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_flutter_03/detail/detail_state.dart';
import 'package:to_do_flutter_03/to_do_Repository.dart';
 
class DetailViewModel {
  final TodoRepository repo;
  DetailViewModel({required this.repo});
 
  Future<int> update({
    required int id,
    String? title,
    String? description,
  }) {
    return repo.updateTodo(id: id, title: title, description: description);
  }
 
  Future<int> delete({required int id}) {
    return repo.deleteTodo(id: id);
  }
}
 
class DetailCubit extends Cubit<DetailState> {
  final DetailViewModel vm;
  DetailCubit({required DetailState initial, required this.vm})
      : super(initial);
 
  void setTitle(String value) {
    emit(state.copyWith(title: value));
  }
 
  void setDescription(String? value) {
    emit(state.copyWith(description: value));
  }
 
  Future<void> save() async {
    emit(state.copyWith(isLoading: true, error: null, completedAction: false));
    try {
      await vm.update(
        id: state.id,
        title: state.title,
        description: state.description,
      );
      emit(state.copyWith(isLoading: false, completedAction: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
 
  Future<void> remove() async {
    emit(state.copyWith(isLoading: true, error: null, completedAction: false));
    try {
      await vm.delete(id: state.id);
      emit(state.copyWith(isLoading: false, completedAction: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
