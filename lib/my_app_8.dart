import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class MyApp8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp8 is built');
    return HogeWidget();
  }
}

class HogeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<_HogeBloc>(
      builder: (_) => _HogeBloc(),
      dispose: (_, _HogeBloc bloc) => bloc.dispose(),
      child: Column(
        children: <Widget>[
          WidgetA(),
          WidgetB(),
        ],
      ),
    );
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
  @override
  Widget build(BuildContext context) {
    print('WidgetA is built.');
    return RaisedButton.icon(
      icon: Icon(Icons.plus_one),
      label: Text('plus 1'),
      // Provider経由で、HogeBlocのincrementというSinkにnullを投げ入れる
      onPressed: () => Provider.of<_HogeBloc>(context).increment.add(null),
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
        StreamBuilder(
          // Provider経由で受け取っているStreamに応答してリビルド
          stream: Provider.of<_HogeBloc>(context).counter,
          builder: (_, AsyncSnapshot snapshot) =>
              Text(snapshot.data.toString()),
        ),
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
