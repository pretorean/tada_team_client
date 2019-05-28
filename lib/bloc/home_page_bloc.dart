import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tada_team_client/bloc/home_page_event.dart';
import 'package:tada_team_client/bloc/home_page_state.dart';
import 'package:tada_team_client/tada_service.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({@required this.service}) {
    service.addListener(_messageHandler);
  }

  @override
  HomePageState get initialState => OfflineState(error: '');

  final TadaTeamService service;

  @override
  void dispose() {
    service.removeListener(_messageHandler);
    super.dispose();
  }

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is ConnectEvent) {
      yield LoadingState();
      try {
        await service.initCommunication();
      } catch (error) {
        yield OfflineState(error: error.toString());
      }
    }

    if (event is ReceiveEvent) {
      try {
        Map<String, dynamic> message = json.decode(event.message);
        if (message.containsKey('state')) {
          int state = message['state'];
          yield OnlineState(value: state);
        }
      } catch (error) {
        yield OfflineState(error: error.toString());
      }
    }

    if (event is SendEvent) {
      try {
        service.send(json.encode({'state': event.state == 0 ? 1 : 0}));
      } catch (error) {
        yield OfflineState(error: error.toString());
      }
    }
  }

  void _messageHandler(String message) {
    print(message);
    dispatch(ReceiveEvent(message: message));
  }
}
