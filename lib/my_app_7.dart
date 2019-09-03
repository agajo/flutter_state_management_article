import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class MyApp7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp7 is built');
    return HogeWidget();
  }
}

// Blocが不要になった時にdispose()を呼ぶため、Stateのdispose関数を利用する。そのためのStatefulWidget
class HogeWidget extends StatefulWidget {
  @override
  _HogeWidgetState createState() => _HogeWidgetState();
}

class _HogeWidgetState extends State<HogeWidget> {
  final _HogeBloc _hogeBloc = _HogeBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 下位層のコンストラクタに随時Blocを渡していく
        WidgetA(_hogeBloc),
        WidgetB(_hogeBloc),
      ],
    );
  }

  @override
  dispose() {
    _hogeBloc.dispose();
    super.dispose();
  }
}

// Blocを作成。
class _HogeBloc {
  _HogeBloc() {
    // 初期値は最初に流しておく
    _counterController.add(_counter);
    // incrementにnullが投げ入れられたら、_counterを1増やしてStreamに流す
    _incrementController.stream.listen((_) {
      _counter++;
      _counterController.add(_counter);
    });
  }

  int _counter = 0;
  final StreamController<void> _incrementController = StreamController<void>();
  final BehaviorSubject<int> _counterController = BehaviorSubject<int>();
  Stream<int> get counter => _counterController.stream;
  StreamSink<void> get increment => _incrementController.sink;

  void dispose() {
    _incrementController.close();
    _counterController.close();
  }
}

class WidgetA extends StatelessWidget {
  WidgetA(this._hogeBloc);
  final _HogeBloc _hogeBloc;
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // 受け取っているHogeBlocのincrementというSinkにnullを投げ入れる
      onPressed: () => _hogeBloc.increment.add(null),
    );
  }
}

class WidgetB extends StatelessWidget {
  WidgetB(this._hogeBloc);
  final _HogeBloc _hogeBloc;
  final WidgetD _widgetD = WidgetD();
  @override
  Widget build(BuildContext context) {
    print('WidgetB is built');
    return WidgetC(_hogeBloc, child: _widgetD);
  }
}

class WidgetC extends StatelessWidget {
  WidgetC(this._hogeBloc, {this.child});
  final _HogeBloc _hogeBloc;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    print('WidgetC is built.');
    return Column(
      children: <Widget>[
        StreamBuilder(
          // 受け取っているHogeBlocのStreamに応答してリビルド
          stream: _hogeBloc.counter,
          builder: (_, AsyncSnapshot snapshot) =>
              Text(snapshot.data.toString()),
        ),
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
