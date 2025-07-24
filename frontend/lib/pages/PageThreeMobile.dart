import 'dart:async';

import 'package:desbingo/providers/UserProvider.dart';
import 'package:desbingo/providers/page_provider.dart';
import 'package:desbingo/widgets/_fevoriteNumbers.dart';
import 'package:desbingo/widgets/number_picker_widget.dart';
import 'package:desbingo/widgets/profile_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageThreeMobile extends StatefulWidget {
  final int duration;
  const PageThreeMobile({super.key, required this.duration});

  @override
  State<PageThreeMobile> createState() => _PageThreeMobileState();
}

class _PageThreeMobileState extends State<PageThreeMobile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<List<int>> _favoriteSets = [];
  String? _savedName;
  String? _savedPhone;
  String? _deviceId;
  double? account_balance_wallet = 0.0;

  int? _selectedFavoriteIndex; // <-- Track selected favorite card
    late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _startCountdown();
    _secondsRemaining = widget.duration; // ✅ initialize with widget.duration
  }

  Future<void> _initializeUser() async {
    await _loadUserData(); // ensures _deviceId is set
    await _loadUserDataFromFirebase(); // safe to fetch balance now
  }

  Future<void> _loadUserDataFromFirebase() async {
    if (_deviceId == null) return; // Still good to keep this
    try {
      final doc = await FirebaseFirestore.instance
          .collection('players')
          .doc(_deviceId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (mounted) {
          setState(() {
            _savedName = data?['name'];
            _savedPhone = data?['phone'];
            account_balance_wallet = (data?['balance'] ?? 0).toDouble();
          });
        }
      }
    } catch (e) {
      print('❌ Error fetching user data: $e');
    }
  }

  Future<void> _saveUserDataToFirebase() async {
    if (_deviceId == null) return;

    final playerData = {
      'name': _savedName,
      'phone': _savedPhone,
      'updated_at': FieldValue.serverTimestamp(),
      'device_id': _deviceId,
      'balance': 25,
    };

    await FirebaseFirestore.instance
        .collection('players')
        .doc(_deviceId)
        .set(playerData, SetOptions(merge: true));
  }

  Future<void> _deductBalance(double amount) async {
    if (_deviceId == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('players')
        .doc(_deviceId);

    try {
      final doc = await userRef.get();
      if (doc.exists) {
        final currentBalance = (doc['balance'] ?? 0).toDouble();

        if (currentBalance >= amount) {
          final newBalance = currentBalance - amount;
          await userRef.update({'balance': newBalance});
          setState(() {
            account_balance_wallet = newBalance;
          });
        } else {
          // Insufficient balance
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Not enough balance to play.')),
          );
        }
      }
    } catch (e) {
      print("🔥 Failed to deduct balance: $e");
    }
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  Future<void> _saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_id', deviceId);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name');
    final phone = prefs.getString('player_phone');
    final storedDeviceId = prefs.getString('device_id');
    final setsString = prefs.getString('favorite_sets');

    if (storedDeviceId == null) {
      final newId = await _getDeviceId();
      await _saveDeviceId(newId);
      setState(() {
        _deviceId = newId;
      });
    } else {
      setState(() {
        _deviceId = storedDeviceId;
      });
    }

    setState(() {
      _savedName = name;
      _savedPhone = phone;
      if (setsString != null) {
        final List<dynamic> rawSets = jsonDecode(setsString);
        _favoriteSets = rawSets
            .map<List<int>>((e) => List<int>.from(e))
            .toList();
      }
    });
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', name);
    setState(() {
      _savedName = name;
    });
  }

  Future<void> _savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_phone', phone);
    setState(() {
      _savedPhone = phone;
    });
  }

  Future<void> _saveFavoriteSets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorite_sets', jsonEncode(_favoriteSets));
  }

  void _showNumberPicker({int? editIndex}) {
    List<int> initial = [];
    if (editIndex != null) {
      initial = List.from(_favoriteSets[editIndex]);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return NumberPickerWidget(
          initialSelection: initial,
          maxPick: 4,
          onNumbersPicked: (pickedNumbers) async {
            setState(() {
              if (editIndex != null) {
                _favoriteSets[editIndex] = pickedNumbers;
              } else {
                _favoriteSets.add(pickedNumbers);
              }
            });
            await _saveFavoriteSets();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildTopProfileCard() {
    return ProfileShowWidget(
      userName: _savedName,
      phone: _savedPhone,
      deviceId: _deviceId,
      balance: account_balance_wallet,
    );
  }

  Widget _buildFavoriteCard(List<int> set, int index) {
    bool isSelected = _selectedFavoriteIndex == index;
    return FavoriteNumberCard(
      numbers: set,
      index: index,
      backgroundColor: isSelected ? Colors.pinkAccent.withOpacity(0.7) : null,
      onEdit: (idx) => _showNumberPicker(editIndex: idx),
      onDelete: (idx) {
        setState(() {
          _favoriteSets.removeAt(idx);
          if (_selectedFavoriteIndex == idx) _selectedFavoriteIndex = null;
        });
        _saveFavoriteSets();
      },
     
      onPlay: (idx) async {
        if (account_balance_wallet != null && account_balance_wallet! >= 5) {
          await _deductBalance(5); // deduct 5 birr per play
          setState(() {
            _selectedFavoriteIndex = idx;
          });
          final provider = Provider.of<PageProvider>(context, listen: false);
          provider.registerUser(_deviceId!, _favoriteSets[idx]);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Game started with selected numbers!"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Not enough balance to play.")),
          );
        }
      },
    );
  }

    void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

   String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUserInfo =
        _savedName != null &&
        _savedName!.isNotEmpty &&
        _savedPhone != null &&
        _savedPhone!.isNotEmpty;

    return Scaffold(
      floatingActionButton: hasUserInfo
          ? FloatingActionButton(
              onPressed: _showNumberPicker,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            )
          : null,
      
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: hasUserInfo
              ? Column(
                  children: [
                    _buildTopProfileCard(),
                    Expanded(
                      child: _favoriteSets.isEmpty
                          ? const Center(
                              child: Text(
                                'No favorite sets yet.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _favoriteSets.length,
                              itemBuilder: (context, index) =>
                                  _buildFavoriteCard(
                                    _favoriteSets[index],
                                    index,
                                  ),
                            ),
                    ),
                  ],
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Please Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final name = _nameController.text.trim();
                              final phone = _phoneController.text.trim();

                              if (name.isEmpty || phone.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter both name and phone',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final provider = Provider.of<Userprovider>(
                                context,
                                listen: false,
                              );
                              provider.createUser(name, phone!);

                              // Save data
                              await _saveName(name);
                              await _savePhone(phone);
                              await _saveUserDataToFirebase();

                              if (_deviceId == null) {
                                final newId = await _getDeviceId();
                                await _saveDeviceId(newId);
                                setState(() {
                                  _deviceId = newId;
                                });
                              }

                              // Clear inputs
                              _nameController.clear();
                              _phoneController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.grey.shade200,
        child: Center(
          child: Text(
            '⏳ Timer: ${_formatTime(_secondsRemaining)}',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
