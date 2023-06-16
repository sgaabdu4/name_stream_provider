import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Frank',
  'Grace',
  'Henry',
  'Ivy',
  'Jack'
];

//value from 1 and adds to it
final tickerProvider = StreamProvider<int>(
    (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1));

//this is deprecated so needs to figure out what the alternative is
final namesProvider = StreamProvider((ref) =>
    ref.watch(tickerProvider.stream).map((count) => names.getRange(0, count)));

//The recommendation is instead of
// final namesProvider = StreamProvider((ref) =>
//     ref.watch(tickerProvider.stream).map((count) => names.getRange(0, count)));

// Do this instead:
// final namesProvider1 = FutureProvider((ref) async {
//   final count = await ref.watch(tickerProvider.future);
//   return names.getRange(0, count);
// });

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Name Streamer')),
        body: names.when(
            data: (names) {
              return ListView.builder(
                  itemCount: names.length,
                  itemBuilder: ((context, index) => ListTile(
                        title: Text(names.elementAt(index)),
                      )));
            },
            error: (error, stackTrace) => const Text('Reached end of list'),
            loading: () => const CircularProgressIndicator()));
  }
}
