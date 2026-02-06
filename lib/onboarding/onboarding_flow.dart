import 'package:flutter/material.dart';
import 'package:to_do_flutter_03/home/home_Page.dart';
import 'package:to_do_flutter_03/services/app_preferences.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final controller = PageController();
  int page = 0;

  void next() {
    if (page == 1) {
      finish();
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void back() {
    if (page > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> finish() async {
    await AppPreferences.instance.setSeenOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'ToDo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: finish,
                    child: const Text(
                      "Пропустить",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (i) => setState(() => page = i),
                children: const [
                  OnboardingPageOne(),
                  OnboardingPageTwo(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dot(active: page == 0),
                Dot(active: page == 1),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Row(
                children: [
                  if (page == 1)
                    TextButton.icon(
                      onPressed: back,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      label: const Text(
                        "Назад",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  else
                    const SizedBox(width: 90),
                  const Spacer(),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: next,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        page == 1 ? "Начать" : "Далее",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE44332),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.checklist, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 18),
          const Text(
            "Todolist",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 36),
          const Text(
            "Добро пожаловать!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          const Text(
            "Организуйте свою жизнь\nс Todoist - приложение для\nуправления задачами",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 40),
          Image.asset(
            "images/image_2.png",
            height: 220,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/image_1.png",
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "Все задачи\nв одном месте",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Добавляйте упорядочивайте\nи управляйте задачами на день,\nнеделю и месяц",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final bool active;
  const Dot({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
