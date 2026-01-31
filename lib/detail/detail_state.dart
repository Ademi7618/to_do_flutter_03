import 'package:to_do_flutter_03/database/app_databese.dart';

class DetailState {
  final int id;
  final String title;
  final String? description;
  final bool isLoading;
  final String? error;
  final bool completedAction;
 
  const DetailState({
    required this.id,
    required this.title,
    required this.description,
    required this.isLoading,
    required this.error,
    required this.completedAction,
  });
 
  factory DetailState.fromTodo(Todo todo) => DetailState(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isLoading: false,
        error: null,
        completedAction: false,
      );
 
  DetailState copyWith({
    int? id,
    String? title,
    String? description,
    bool? isLoading,
    String? error,
    bool? completedAction,
  }) {
    return DetailState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      completedAction: completedAction ?? this.completedAction,
    );
  }
}
