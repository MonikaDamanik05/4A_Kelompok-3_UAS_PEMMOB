part of 'counter_cubit.dart';

@immutable
class CounterState {
  final int counter;
  final String? status;
  final Color color;
  const CounterState({required this.counter, this.status, required this.color,});
}

final class CounterInitialState extends CounterState {
  const CounterInitialState() : super(counter: 0, status: 'Genap', color: const Color.fromARGB(255, 243, 33, 215) ); //kondisi awal
}