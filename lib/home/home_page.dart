import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_flutter_03/database/app_databese.dart';
import 'package:to_do_flutter_03/detail/detail_page.dart';
import 'package:to_do_flutter_03/home/home_state.dart';
import 'package:to_do_flutter_03/home/home_view_model.dart';
import 'package:to_do_flutter_03/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomeCubit cubit;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    final vm = HomeViewModel(repo: repository);
    cubit = HomeCubit(vm: vm)..init();
  }

  Future<void> loadVolue() async {
    prefs = await SharedPreferences.getInstance();

    print('isDarkThem: ${prefs.getBool('isDarkThem')}');
    print('pogress: ${prefs.getInt('pogress')}');
    print('username: ${prefs.getString('username')}');
  }

  Future<void> saveValue() async {
     prefs = await SharedPreferences.getInstance();

    prefs.setBool('isDarkThem', false);
    prefs.setInt('progress', 60);
    prefs.setString('username', 'Nursultan');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current)=> previous.error != current.error && current!= null,
        listener:(context, state){
          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Вы не заполнили название задачи!'),
           )
          );
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: const Color(0xFF56856D),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Заметки',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Поиск (визуально)
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Искать заметки',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final Todo item = state.items[index];
                        return _NoteCard(
                          todo: item,
                          onTap: () async {
                            final bool? needRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(todo: item),
                              ),
                            );

                            if (needRefresh == true) {
                              cubit.init();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF007AFF),
              onPressed: () async {
                final todo = await context.read<HomeCubit>().createAndGetNew();
                if (!context.mounted) return;
                if (todo != null) {
                  final bool? needRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(todo: todo)),
                  );
                  if (needRefresh == true) {
                    cubit.init();
                  }
                } else {
                  cubit.init();
                }
              },
              child: const Icon(Icons.add, size: 32),
            ),
          );
        },
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const _NoteCard({required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              todo.description ?? 'Без описания',
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                todo.date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
