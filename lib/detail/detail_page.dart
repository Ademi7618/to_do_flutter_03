import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_flutter_03/database/app_databese.dart';
import 'package:to_do_flutter_03/detail/detail_state.dart';
import 'package:to_do_flutter_03/detail/detail_view_model.dart';
import 'package:to_do_flutter_03/main.dart';

class DetailPage extends StatefulWidget {
  final Todo todo;

  const DetailPage({super.key, required this.todo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final DetailCubit cubit;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description ?? '',
    );
    final vm = DetailViewModel(repo: repository);
    cubit = DetailCubit(initial: DetailState.fromTodo(widget.todo), vm: vm);
  }

  Future<void> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить заметку?'),
        content: const Text('Действие нельзя отменить'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Да'),
          ),
        ],
      ),
    );
    if (result == true) {
      await cubit.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<DetailCubit, DetailState>(
        listenWhen: (prev, curr) =>
            prev.completedAction != curr.completedAction,
        listener: (context, state) {
          if (state.completedAction) {
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF6F6F6),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Text(
                  'Детали',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _confirmDelete,
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Image.asset('assets/image.png', width: 287, height: 226),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Название',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _titleController,
                              onChanged: context.read<DetailCubit>().setTitle,
                              decoration: InputDecoration(
                                hintText: 'Введите название',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Описание',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 4,
                              onChanged: context
                                  .read<DetailCubit>()
                                  .setDescription,
                              decoration: InputDecoration(
                                hintText: 'Введите описание',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: CupertinoButton(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(14),
                          onPressed: state.isLoading
                              ? null
                              : context.read<DetailCubit>().save,
                          child: const Text(
                            'Сохранить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
