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
  final WidgetA _widgetA = WidgetA();
  final WidgetB _widgetB = WidgetB();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => _HogeChangeNotifier(),
      child: Column(
        children: <Widget>[
          _widgetA,
          _widgetB,
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
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC(child: _widgetD);
  }
}

class WidgetC extends StatelessWidget {
  WidgetC({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        // このConsumerの傘下だけがリビルドされる。
        Consumer<_HogeChangeNotifier>(
            builder: (_, _HogeChangeNotifier hoge, __) =>
                Text(hoge._counter.toString())),
        child,
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
