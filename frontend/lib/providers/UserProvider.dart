import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userprovider extends ChangeNotifier {
  String? _deviceId;
  String? _name;
  String? _phone;
  double _balance = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get deviceId => _deviceId;
  String? get name => _name;
  String? get phone => _phone;
  double get balance => _balance;

  bool get isRegistered =>
      _name != null && _name!.isNotEmpty &&
      _phone != null && _phone!.isNotEmpty;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    _deviceId = prefs.getString('device_id') ?? await _generateDeviceId();
    _name = prefs.getString('player_name');
    _phone = prefs.getString('player_phone');
    _balance = prefs.getDouble('balance') ?? 0.0;

    // If local data is missing, fetch from Firebase
    if (_name == null || _phone == null) {
      await _fetchUserFromFirebase();
    }

    notifyListeners();
  }

  Future<String> _generateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final info = DeviceInfoPlugin();
    final androidInfo = await info.androidInfo;
    final id = androidInfo.id;
    await prefs.setString('device_id', id);
    return id;
  }

  /// 🔹 Create new user (also saves to Firebase and local)
  Future<void> createUser(String name, String phone) async {
    if (_deviceId == null) {
      _deviceId = await _generateDeviceId();
    }

    _name = name;
    _phone = phone;
    _balance = 50.0; // Default initial balance

    // Save to Firestore
    await _firestore.collection('Kenousers').doc(_deviceId).set({
      'name': name,
      'phone': phone,
      'deviceId': _deviceId,
      'balance': _balance,
    });

    // Save locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', name);
    await prefs.setString('player_phone', phone);
    await prefs.setDouble('balance', _balance);

    notifyListeners();
  }

  /// 🔹 Fetch user from Firebase if local is missing
  Future<void> _fetchUserFromFirebase() async {
    if (_deviceId == null) return;
    final doc = await _firestore.collection('users').doc(_deviceId).get();

    if (doc.exists) {
      final data = doc.data()!;
      _name = data['name'];
      _phone = data['phone'];
      _balance = (data['balance'] as num).toDouble();

      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('player_name', _name!);
      await prefs.setString('player_phone', _phone!);
      await prefs.setDouble('balance', _balance);

      notifyListeners();
    }
  }

  /// 🔹 Add balance (for wins, etc.)
  Future<void> deposit(double amount) async {
    _balance += amount;
    await _saveBalance();
    notifyListeners();
  }

  /// 🔹 Withdraw balance
  Future<void> withdraw(double amount) async {
    if (amount <= _balance) {
      _balance -= amount;
      await _saveBalance();
      notifyListeners();
    }
  }

  /// 🔹 Update balance in both Firebase and local
  Future<void> _saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', _balance);

    if (_deviceId != null) {
      await _firestore.collection('users').doc(_deviceId).update({
        'balance': _balance,
      });
    }
  }

  /// 🔹 Clear user data locally (used for reset)
  Future<void> clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('player_name');
    await prefs.remove('player_phone');
    await prefs.remove('balance');

    _name = null;
    _phone = null;
    _balance = 0.0;

    notifyListeners();

    // Try fetching from Firebase again
    await _fetchUserFromFirebase();
  }
}
