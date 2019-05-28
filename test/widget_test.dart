import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tada_team_client/client_app.dart';
import 'package:tada_team_client/tada_service.dart';

class TadaTeamServiceMock extends Mock implements TadaTeamService {}

TadaTeamServiceMock getService() {
  TadaTeamServiceMock service = TadaTeamServiceMock();

  return service;
}

void main() {
  testWidgets('connect test', (WidgetTester tester) async {
    final service = getService();
    await tester.pumpWidget(ClientApp(service: service));

    await tester.tap(find.byIcon(Icons.directions_run));
    verify(service.addListener(any)).called(1);
    verify(service.initCommunication()).called(1);
  });
}
