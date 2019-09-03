import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp6 is built');
    return HogeWidget();
  }
}

class HogeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ここからChangeNotifierを下層に渡す
    return ChangeNotifierProvider<_HogeChangeNotifier>(
      builder: (_) => _HogeChangeNotifier(),
      child: Column(
        children: <Widget>[
          WidgetA(),
          WidgetB(),
        ],
      ),
    );
  }
}

class _HogeChangeNotifier extends ChangeNotifier {
  int _counter = 0;
  void increment() {
    _counter++;
    notifyListeners();
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // Provider経由でincrement関数を呼ぶ。listen:falseにより、こちらはリビルドされない。
      onPressed: () =>
          Provider.of<_HogeChangeNotifier>(context, listen: false).increment(),
    );
  }
}

class WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC();
  }
}

class WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        // このConsumerの傘下だけがリビルドされる。
        Consumer<_HogeChangeNotifier>(
            builder: (_, _HogeChangeNotifier hoge, __) =>
                Text(hoge._counter.toString())),
        WidgetD(),
      ],
    );
  }
}

class WidgetD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetD is built.');
    return Text('WidgetD');
  }
}
