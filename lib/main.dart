import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var record = <WordPair>[];

  void getNext() {
    record.add(current);
    current = WordPair.random();
    notifyListeners();
  }

  String generateFoo() => 'foo';
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int appStateIndex = 0; // Track the selected index here

  void _onDestinationSelected(int index) {
    setState(() {
      appStateIndex = index; // Update index and trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Determine which widget to show based on appStateIndex
    Widget mainPartWidget = appStateIndex == 0
        ? HomeMainPart(
            pair: appState.current, // Use appState.current for consistency
            appState: appState,
          )
        : Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
              width: 2.0,
            )),
            child: SizedBox(
                height: 200,
                width: 150,
                child: SavedTextList(appState: appState)),
          );

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              MainNavBar(
                selectedIndex: appStateIndex,
                onDestinationSelected: _onDestinationSelected,
                constraints: constraints,
              ),
              mainPartWidget,
            ],
          ),
        ),
      );
    });
  }
}

class MainNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final BoxConstraints constraints;

  const MainNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationRail(
        extended: constraints.maxWidth >= 500,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text('Home$selectedIndex'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

class HomeMainPart extends StatelessWidget {
  const HomeMainPart({
    super.key,
    required this.pair,
    required this.appState,
  });

  final WordPair pair;
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LowerCaseCard(pair: pair),
          Text(appState.current.asLowerCase, style: TextStyle(fontSize: 20)),
          ChangePairBtn(appState: appState),
        ],
      ),
    );
  }
}

class SavedTextList extends StatelessWidget {
  const SavedTextList({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appState.record.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(appState.record[index].asLowerCase),
        );
      },
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
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 45, 45));
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.error, fontSize: 30);

    return Card(
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
