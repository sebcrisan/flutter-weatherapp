import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// provider scope
void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

// state notifier provider
final counterProvider = StateNotifierProvider<Counter, int>(
  (ref) => Counter(),
);

// state notifier, counter class
class Counter extends StateNotifier<int> {
  /// Init with 0
  Counter() : super(0);

  /// Increment counter
  void incrementCounter() {
    state++;
  }

  /// Get the current count value
  int get value => state;
}

// Counter app with dark theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Counter App'),
    );
  }
}

// Home page screen
class MyHomePage extends ConsumerWidget {
  /// Init homepage
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  /// The title of the homepage
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            /// The counter
            final count = ref.watch(counterProvider);

            /// The count
            final text = count <= 0 ? "Press the button" : count.toString();

            return Text(text);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: ref.read(counterProvider.notifier).incrementCounter,
            child: const Text('Increment count'),
          ),
        ],
      ),
    );
  }
}
