import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StorageProvider(),
      child: MyApp(),
    ),
  );
}

class StorageProvider with ChangeNotifier {
  Model _model;

  Model get model => _model;

  void loadData() {
    _model = Model("Jack", 25);
    notifyListeners();
  }
}

class Model {
  final String name;
  final int age;

  Model(this.name, this.age);

  @override
  String toString() {
    return "$name($age)";
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (ctx) => FirstScreen(),
        "/screen2": (ctx) => SecondScreen(),
      },
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First screen"),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<StorageProvider>(
            builder: (ctx, provider, child) => Text(
              provider.model?.toString() ?? "Not loaded yet!",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 36),
            child: RaisedButton(
              child: Text("Load data"),
              onPressed: () => context.read<StorageProvider>().loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second screen")),
      drawer: AppDrawer(),
      body: Center(
        child: Consumer<StorageProvider>(
          builder: (ctx, provider, child) => Text(provider.model?.toString() ?? "Not loaded yet!"),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      child: Column(
        children: [
          AppBar(
            title: Text("Example"),
            automaticallyImplyLeading: false,
          ),
          _buildDrawerOption(context, "Screen 1", () => _switchTo(context, "/")),
          _buildDrawerOption(context, "Screen 2", () => _switchTo(context, "/screen2")),
        ],
      ),
    );
  }

  _buildDrawerOption(BuildContext context, String title, Function action) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 24)),
      onTap: action,
    );
  }

  void _switchTo(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
