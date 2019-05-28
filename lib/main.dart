import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tada_team_client/bloc/client_app_bloc_delegate.dart';
import 'package:tada_team_client/client_app.dart';
import 'package:tada_team_client/tada_service.dart';

void main() {
  BlocSupervisor().delegate = ClientAppBlocDelegate();

  final TadaTeamService service = TadaTeamService();

  runApp(ClientApp(service: service));
}
