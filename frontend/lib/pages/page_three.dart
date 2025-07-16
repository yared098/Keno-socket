import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageThree extends StatefulWidget {
  final int duration;
  const PageThree({super.key, required this.duration});

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  final TextEditingController _nameController = TextEditingController();
  final List<int> _selectedNumbers = [];

  void _showRegisterDialog(BuildContext context) {
    _nameController.clear();
    _selectedNumbers.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('🎯 Register Player'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Player Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Pick up to 10 numbers:'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(80, (index) {
                    final number = index + 1;
                    final isSelected = _selectedNumbers.contains(number);
                    return ChoiceChip(
                      label: Text(
                        '$number',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        setState(() {
                          if (selected && _selectedNumbers.length < 10) {
                            _selectedNumbers.add(number);
                          } else {
                            _selectedNumbers.remove(number);
                          }
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty && _selectedNumbers.isNotEmpty) {
                  Provider.of<PageProvider>(context, listen: false).registerUser(
                    name,
                    List.from(_selectedNumbers),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PageProvider>(context, listen: false).clearUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<PageProvider>(context).registeredUsers;

    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegisterDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Register'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                '📋 Registered Users',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '⏱ Duration: ${widget.duration} seconds',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: users.isEmpty
                    ? const Center(
                        child: Text(
                          'No registered users yet.',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final name = user['name'];
                          final numbers = List<int>.from(user['numbers']);

                          return Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('🎲 Numbers: ${numbers.join(', ')}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
