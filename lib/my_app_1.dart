import 'package:flutter/material.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HogeStatefulWidget();
  }
}

// Stateをグローバル変数として持つ
_HogeStatefulWidgetState _state = _HogeStatefulWidgetState();

class HogeStatefulWidget extends StatefulWidget {
  @override
  _HogeStatefulWidgetState createState() => _state;
}

class _HogeStatefulWidgetState extends State<HogeStatefulWidget> {
  // WidgetAとWidgetDのコンストラクタはbuild()内で呼ばないので、setState()時にリビルドされない
  final WidgetA _widgetA = WidgetA();
  final WidgetD _widgetD = WidgetD();
  int _counter = 0;
  void increment() => setState(() => _counter++);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetA,
        WidgetB(child: WidgetC(count: _counter, child: _widgetD)),
      ],
    );
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      onPressed: () {
        // グローバル変数である_stateが持つ更新関数を直接呼ぶ
        _state.increment();
      },
    );
  }
}

class WidgetB extends StatelessWidget {
  WidgetB({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return child;
  }
}

class WidgetC extends StatelessWidget {
  WidgetC({this.count, this.child});
  final Widget child;
  final int count;
  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        Text(count.toString()),
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
