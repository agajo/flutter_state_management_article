import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp9 is built');
    return HogeWidget();
  }
}

class HogeWidget extends StatelessWidget {
  final _HogeValueNotifier _hogeValueNotifier = _HogeValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    // ここからintを下層に渡す
    return ValueListenableProvider<int>(
      builder: (_) => _hogeValueNotifier,
      child: Column(
        children: <Widget>[
          WidgetA(_hogeValueNotifier.increment),
          WidgetB(),
        ],
      ),
    );
  }
}

class _HogeValueNotifier extends ValueNotifier<int> {
  _HogeValueNotifier(value) : super(value);
  void increment() {
    value++;
    // notifyListeners(); は不要。valueの変更は自動で検知される。
  }
}

class WidgetA extends StatelessWidget {
  WidgetA(this.incrementer);
  final void Function() incrementer;
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // 既に受け取っているincrementerを呼ぶだけ
      onPressed: () => incrementer(),
    );
  }
}

class WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC(WidgetD());
  }
}

class WidgetC extends StatelessWidget {
  WidgetC(this.child);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        // ここで、リビルド対象として登録される。
        Text(Provider.of<int>(context).toString()),
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
