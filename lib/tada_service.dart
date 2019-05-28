import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

class TadaTeamService {
  final String _url = 'ws://pm.tada.team/ws';

  IOWebSocketChannel _channel;

  bool _isOn = false;

  // подписчики
  ObserverList<Function> _listeners = new ObserverList<Function>();

  // инициализация
  Future initCommunication() async {
    reset();
    _channel = new IOWebSocketChannel.connect(_url);
    _channel.stream.listen(_internalMessageHandler);
  }

  // закрыть соединение
  void reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  // отправить сообщение
  void send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        _channel.sink.add(message);
      }
    }
  }

  // добавить подписчика
  void addListener(Function callback) {
    _listeners.add(callback);
  }

  // удалить подписчика
  void removeListener(Function callback) {
    _listeners.remove(callback);
  }

  // внутренний обработчик
  void _internalMessageHandler(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
