import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initializeSocket() {
    socket = IO.io('http://localhost:9090', IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());
    socket.connect();

    socket.onConnect((_) {
      print('Connected to the server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server');
    });
  }

  void subscribeToStatusUpdates(Function(dynamic) callback) {
    socket.on('status_update', (data) {
      callback(data);
    });
  }

  void dispose() {
    socket.dispose();
  }
}
