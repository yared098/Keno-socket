
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PageProvider extends ChangeNotifier {
  late IO.Socket socket;
  bool _isConnected = false;
bool get isConnected => _isConnected;

  int _currentPage = 1;
  int _duration = 10;
  List<int> drawnNumbers = [];

  final List<Map<String, dynamic>> _registeredUsers = [];

  int get currentPage => _currentPage;
  int get duration => _duration;
  List<Map<String, dynamic>> get registeredUsers => List.unmodifiable(_registeredUsers);
  List<int> get getDrawnNumbers => drawnNumbers;

  PageProvider() {
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io(
      'https://keno-socket.onrender.com/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );

    socket.onConnect((_) {
      print('✅ Connected to backend');
      
        _isConnected = true;
    });

    socket.on('pageChange', (data) {
      print('📥 Received pageChange: $data');
      if (data != null) {
        _currentPage = data['page'] ?? _currentPage;
        _duration = data['duration'] ?? _duration;

        if (data.containsKey('drawnNumbers')) {
          drawnNumbers = List<int>.from(data['drawnNumbers']);
        } else {
          drawnNumbers = [];
        }

        notifyListeners();
      }
    });

    // ✅ NEW: Listen for user updates from backend
    socket.on('registeredUsers', (data) {
      print('👥 Received registeredUsers: $data');
      if (data is List) {
        _registeredUsers
          ..clear()
          ..addAll(List<Map<String, dynamic>>.from(
            data.map((e) => Map<String, dynamic>.from(e)),
          ));
        notifyListeners();
      }
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from backend');
      _isConnected = false;
    });
  }

  void registerUser(String name, List<int> numbers) {
    // Send to backend
    socket.emit('registerUser', {
      'name': name,
      'numbers': numbers,
    });
  }

  void clearUsers() {
    _registeredUsers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}
