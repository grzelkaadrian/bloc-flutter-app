import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:bloc_app/app.dart';
import 'package:bloc_app/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}
