import 'package:desbingo/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PageThreeMobile extends StatefulWidget {
  final int duration;
  const PageThreeMobile({super.key, required this.duration});

  @override
  State<PageThreeMobile> createState() => _PageThreeMobileState();
}

class _PageThreeMobileState extends State<PageThreeMobile> {
  final TextEditingController _nameController = TextEditingController();
  List<int> _selectedNumbers = [];
  String? _savedName;
  List<int>? _savedNumbers;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name');
    final numbersString = prefs.getString('player_numbers');

    setState(() {
      _savedName = name;
      if (numbersString != null) {
        _savedNumbers = List<int>.from(jsonDecode(numbersString));
        _selectedNumbers = List.from(_savedNumbers!);
      } else {
        _savedNumbers = null;
        _selectedNumbers = [];
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

  Future<void> _saveNumbers(List<int> numbers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_numbers', jsonEncode(numbers));
    setState(() {
      _savedNumbers = List.from(numbers);
      _selectedNumbers = List.from(numbers);
    });
  }

  void _showNameInputDialog() {
    _nameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Player Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Your name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _saveName(name);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNumberPicker() {
    _selectedNumbers = List.from(_savedNumbers ?? []);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SizedBox(
            height: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pick up to 10 numbers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(80, (index) {
                        final number = index + 1;
                        final isSelected = _selectedNumbers.contains(number);
                        return ChoiceChip(
                          label: Text('$number'),
                          selected: isSelected,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey[200],
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                if (_selectedNumbers.length < 10) {
                                  _selectedNumbers.add(number);
                                }
                              } else {
                                _selectedNumbers.remove(number);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedNumbers.isNotEmpty) {
                      _saveNumbers(_selectedNumbers);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one number'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save Numbers'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person_add_alt_1, size: 80, color: Colors.white70),
        const SizedBox(height: 20),
        const Text(
          'No player registered yet.',
          style: TextStyle(color: Colors.white70, fontSize: 22),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap the button below to register your name.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _showNameInputDialog,
          icon: const Icon(Icons.person_add),
          label: const Text('Register Name'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPickerPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.format_list_numbered, size: 80, color: Colors.white70),
        const SizedBox(height: 20),
        Text(
          'Hello, $_savedName!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Please pick your numbers to play.',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _showNumberPicker,
          icon: const Icon(Icons.numbers),
          label: const Text('Pick Numbers'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisteredInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.greenAccent),
        const SizedBox(height: 20),
        Text(
          'Registered Player',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade100,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '👤 Name: $_savedName',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          '🎲 Numbers: ${_savedNumbers!.join(', ')}',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          // onPressed: () {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("Game started!")),
          //   );
          // },
          onPressed: () {
            if (_savedName != null &&
                _savedNumbers != null &&
                _savedNumbers!.isNotEmpty) {
              final provider = Provider.of<PageProvider>(
                context,
                listen: false,
              );
              provider.registerUser(_savedName!, _savedNumbers!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Game started! Data sent to server."),
                ),
              );
            }
          },

          icon: const Icon(Icons.play_arrow),
          label: const Text("Play Now"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _showNumberPicker,
          icon: const Icon(Icons.edit, color: Colors.white70),
          label: const Text(
            'Change Numbers',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _savedName == null
                ? _buildRegisterPrompt()
                : (_savedNumbers == null || _savedNumbers!.isEmpty)
                ? _buildNumberPickerPrompt()
                : _buildRegisteredInfo(),
          ),
        ),
      ),
    );
  }
}
