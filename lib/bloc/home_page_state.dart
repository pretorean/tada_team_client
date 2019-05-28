import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomePageState extends Equatable {
  HomePageState([List props = const []]) : super(props);
}

class OfflineState extends HomePageState {
  OfflineState({@required this.error}) : super([error]);

  final String error;

  @override
  String toString() => 'OfflineState{error: $error}';
}

class OnlineState extends HomePageState {
  OnlineState({@required this.value}) : super([value]);

  final int value;

  @override
  String toString() => 'OnlineState{value: $value}';
}

class LoadingState extends HomePageState {
  @override
  String toString() => 'LoadingState{}';
}
