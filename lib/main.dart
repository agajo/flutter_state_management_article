import 'package:flutter/material.dart';
// Change here to select which "my_app_x.dart" to import.
import 'package:flutter_state_management_article/my_app_1.dart';

void main() => runApp(MaterialApp(
        home: Scaffold(
      appBar: AppBar(),
      // Change here to select which "MyAppX" to call.
      body: MyApp1(),
    )));
