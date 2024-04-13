import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proriv_case/di/singletones.dart';
import 'package:proriv_case/presentation/intro_page/intro_view.dart';
import 'package:proriv_case/presentation/intro_page/intro_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проверить продукт',
      home: IntroView(
        viewModel: IntroViewModel(
          webApi: webApi,
          sharedPrefsSource: localDb,
        ),
      ),
    );
  }
}
