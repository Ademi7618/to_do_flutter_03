import 'package:to_do_flutter_03/database/app_databese.dart';

class HomeState {
  final List<Todo> items;
  final bool isLoading;
  final String? error;

  const HomeState({required this.items, required this.isLoading, required this.error});

//состояние по умалспниию
  factory HomeState.initial() => const HomeState(items: [], isLoading: false, error: null);


  HomeState copyWith({
    List<Todo>? items,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(items: items ?? this.items, isLoading: isLoading ?? this.isLoading, error: error ?? error);
  }
}