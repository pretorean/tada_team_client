import 'package:flutter/material.dart';
import 'package:tada_team_client/home_page.dart';
import 'package:tada_team_client/tada_service.dart';

class ClientApp extends StatelessWidget {
  ClientApp({Key key, @required this.service}) : super(key: key);

  final TadaTeamService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaDa!Team Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(
        service: service,
      ),
    );
  }
}
