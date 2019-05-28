import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_client/bloc/home_page_bloc.dart';
import 'package:tada_team_client/bloc/home_page_event.dart';
import 'package:tada_team_client/bloc/home_page_state.dart';
import 'package:tada_team_client/model/message_item.dart';
import 'package:tada_team_client/tada_service.dart';

const _maxMessageListCount = 50;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.service}) : super(key: key);

  final TadaTeamService service;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomePageBloc _bloc;

  List<MessageItem> messageList = [];

  @override
  void initState() {
    _bloc = HomePageBloc(service: widget.service);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageBloc>(
      bloc: _bloc,
      child: BlocBuilder(
        bloc: _bloc,
        builder: _buildWithState,
      ),
    );
  }

  Widget _buildWithState(BuildContext context, HomePageState state) {
    var fab;
    var body;

    if (state is LoadingState) {
      fab = SizedBox.shrink();
      body = Center(child: CircularProgressIndicator());
    }

    if (state is OfflineState) {
      fab = FloatingActionButton.extended(
        icon: Icon(Icons.directions_run),
        label: Text('Старт'),
        onPressed: () => _bloc.dispatch(ConnectEvent()),
      );
      if (state.error.isNotEmpty)
        body = Text(state.error);
      else
        body = SizedBox.shrink();
    }

    if (state is OnlineState) {
      messageList.insert(
          0, MessageItem(state: state.value, date: DateTime.now()));
      if (messageList.length > _maxMessageListCount) messageList.removeLast();

      fab = FloatingActionButton.extended(
        tooltip: 'Изменить состояние',
        icon: Icon(Icons.airplanemode_active),
        label: Text('Отправить ' + (state.value == 0 ? 'preved' : 'medved')),
        onPressed: () => _bloc.dispatch(SendEvent(state: state.value)),
      );
      body = SafeArea(
        child: ListView.builder(
          itemCount: messageList.length,
          itemBuilder: _itemBuilder,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('TaDa!Team Demo'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
      body: body,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Text(messageList[index].date.toString()),
        SizedBox(width: 10),
        Text(messageList[index].state == 0 ? 'preved' : 'medved')
      ],
    );
  }
}
