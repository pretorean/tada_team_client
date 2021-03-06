import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

const String _SERVER_ADDRESS = "ws://192.168.1.45:34263";

class WebSocketsNotifications {
  // The WebSocket "open" channel
  IOWebSocketChannel _channel;

  // Is the connection established?
  bool _isOn = false;

  ///
  /// Listeners
  /// List of methods to be called when a new message
  /// comes in.
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  void initCommunication() async {
    ///
    /// Just in case, close any previous communication
    ///
    reset();

    ///
    /// Open a new WebSocket communication
    ///
    try {
      _channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);

      ///
      /// Start listening to new notifications / messages
      ///
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      ///
      /// General error handling
      /// TODO
      ///
    }
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  void reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  void send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        _channel.sink.add(message);
      }
    }
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  void addListener(Function callback) {
    _listeners.add(callback);
  }

  void removeListener(Function callback) {
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  void _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
