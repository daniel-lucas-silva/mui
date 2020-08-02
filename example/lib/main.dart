import 'package:mui/mui.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Text("teste"),
      ),
      appBar: AppBar(
        floating: true,
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: OutlineButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => Page2()),
            );
          },
          child: Text('Page2'),
        ),
      ),
    );
  }
}


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        floating: false,
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('Teste'),
      ),
    );
  }
}
