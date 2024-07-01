// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterInitialState());

  void increment() {
    final newCounter = state.counter + 1;
    final newStatus = newCounter % 2 == 0 ? 'Genap' : 'Ganjil';
    final Color newColor = newCounter % 2 == 0 ? const Color.fromARGB(255, 243, 33, 215) : const Color.fromARGB(255, 177, 59, 255);
    emit(CounterState(counter: newCounter, status: newStatus, color: newColor));
  }

  void decrement() {
    final newCounter = state.counter - 1;
    final newStatus = newCounter % 2 == 0 ? 'Genap' : 'Ganjil';
    final Color newColor = newCounter % 2 == 0 ? const Color.fromARGB(255, 243, 33, 215) : const Color.fromARGB(255, 216, 59, 255);
    emit(CounterState(counter: newCounter, status: newStatus, color: newColor));
  }
}