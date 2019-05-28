import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomePageEvent extends Equatable {
  HomePageEvent([List props = const []]) : super(props);
}

class ConnectEvent extends HomePageEvent {
  @override
  String toString() => 'ConnectEvent{}';
}

class SendEvent extends HomePageEvent {
  SendEvent({@required this.state});

  final int state;

  @override
  String toString() => 'SendEvent{state: $state}';
}

class ReceiveEvent extends HomePageEvent {
  ReceiveEvent({@required this.message}) : super([message]);

  final String message;

  @override
  String toString() => 'ReceiveEvent{message: $message}';
}
