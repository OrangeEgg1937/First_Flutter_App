import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  String generateFoo() => 'foo';
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LowerCaseCard(pair: pair),
            Text(appState.current.asLowerCase),
            ChangePairBtn(appState: appState),
          ],
        ),
      ),
    );
  }
}

class ChangePairBtn extends StatelessWidget {
  const ChangePairBtn({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        appState.getNext();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Next'),
        ),
      ),
    );
  }
}

class LowerCaseCard extends StatelessWidget {
  const LowerCaseCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme =
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 248, 255, 45));
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return Card(
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
