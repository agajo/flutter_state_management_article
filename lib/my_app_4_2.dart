import 'package:flutter/material.dart';

class MyApp42 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp42 is built');
    return HogeStatefulWidget();
  }
}

class HogeStatefulWidget extends StatefulWidget {
  @override
  _HogeStatefulWidgetState createState() => _HogeStatefulWidgetState();
}

class _HogeStatefulWidgetState extends State<HogeStatefulWidget> {
  WidgetA _widgetA = WidgetA();
  WidgetB _widgetB = WidgetB();
  int _counter = 0;
  void increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    // setStateが呼ばれるたびにこのbuild関数が呼ばれ、新しい_HogeInheritedWidgetが作られて古いものと交換される
    return _HogeInheritedWidget(
      hogeStatefulWidgetState: this,
      counter: _counter,
      child: Column(
        children: <Widget>[
          _widgetA,
          _widgetB,
        ],
      ),
    );
  }
}

class _HogeInheritedWidget extends InheritedWidget {
  _HogeInheritedWidget(
      {Widget child, this.counter, this.hogeStatefulWidgetState})
      : super(child: child);
  final int counter;
  final _HogeStatefulWidgetState hogeStatefulWidgetState;
  @override
  bool updateShouldNotify(_HogeInheritedWidget oldWidget) =>
      oldWidget.counter != counter;
  static _HogeInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_HogeInheritedWidget);
  static _HogeInheritedWidget of2(BuildContext context) => context
      .ancestorInheritedElementForWidgetOfExactType(_HogeInheritedWidget)
      .widget;
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // InheritedWidget経由でincrement関数を呼ぶ
      onPressed: () =>
          _HogeInheritedWidget.of2(context).hogeStatefulWidgetState.increment(),
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
        // ここでWidgetCが_HogeInheritedWidgetのリビルド対象として登録される
        Text(_HogeInheritedWidget.of(context).counter.toString()),
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
