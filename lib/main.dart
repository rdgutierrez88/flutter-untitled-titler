import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tells Flutter to run the app defined in MyApp.
void main() {
  runApp(const MyApp());
}

// Creates the app-wide state,
// names the app, defines the visual theme,
// and sets the "home" widget—the starting point of your app
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// Defines the data the app needs to function
// ChangeNotifier notifies others about its own changes (duh?)
// This state is created and provided to the whole app
// using the ChangeNotifierProvider in MyApp
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  // Reassigns current with a new random WordPair.
  // It also calls notifyListeners()(a method of ChangeNotifier)
  // that ensures that anyone watching MyAppState is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Automatically called every time the widget's circumstances change
  // so that the widget is always up to date
  @override
  Widget build(BuildContext context) {
    // Tracks changes to the app's current state using this watch method
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // Every build method must return a widget
    // or (more typically) a nested tree of widgets.
    // In this case, the top-level widget is Scaffold.
    // You aren't going to work with Scaffold in this codelab,
    // but it's a helpful widget
    // and is found in the vast majority of real-world Flutter apps.
    return Scaffold(
      // One of the most basic layout widgets in Flutter.
      // It takes any number of children
      // and puts them in a column from top to bottom.
      // By default, the column visually places its children at the top.
      // You'll soon change this so that the column is centered.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: const Text('Like'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asCamelCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
