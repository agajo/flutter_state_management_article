import 'package:flutter/material.dart';

class MyApp0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp0 is built');
    return HogeWidget();
  }
}

class HogeWidget extends StatelessWidget {
  // WidgetAとWidgetDはここで生成したものをずっと使うので、リビルドされることはない
  final WidgetA _widgetA = WidgetA();
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetA,
        WidgetB(child: WidgetC(child: _widgetD)),
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
        // グローバル変数であるStateが持つ更新関数を直接呼ぶ
        _widgetCState.increment();
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

class WidgetC extends StatefulWidget {
  WidgetC({this.child});
  final Widget child;

  @override
  // グローバル変数であるStateを返す
  _WidgetCState createState() => _widgetCState;
}

// Stateをグローバル変数として持つ
_WidgetCState _widgetCState = _WidgetCState();

class _WidgetCState extends State<WidgetC> {
  int _count = 0;
  void increment() => setState(() => _count++);
  @override
  Widget build(BuildContext context) {
    print('WidgetCState is built.');
    return Column(
      children: <Widget>[
        Text(_count.toString()),
        widget.child,
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
