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
          title: const Text('Register Player'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(80, (index) {
                    final number = index + 1;
                    final isSelected = _selectedNumbers.contains(number);
                    return ChoiceChip(
                      label: Text('$number'),
                      selected: isSelected,
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
            ElevatedButton(
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
              child: const Text('Register'),
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
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRegisterDialog(context),
        child: const Icon(Icons.person_add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Registered Users\n(Duration: ${widget.duration} seconds)',
              style: const TextStyle(fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
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
                        // final numbers = user['numbers'] as List<int>;
                        final numbers = List<int>.from(user['numbers']);


                        return Card(
                          color: Colors.white24,
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: ListTile(
                            title: Text(name, style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                              'Numbers: ${numbers.join(", ")}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
