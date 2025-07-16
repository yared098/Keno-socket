import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageTwo extends StatelessWidget {
  final int duration;
  const PageTwo({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, _) {
        final drawnNumbers = pageProvider.getDrawnNumbers;
        final registeredUsers = pageProvider.registeredUsers;

        return Scaffold(
          backgroundColor: Colors.green,
          body: SafeArea(
            child: Column(
              children: [
                // Drawn numbers
                Container(
                  height: 70,
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: drawnNumbers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final num = drawnNumbers[index];
                      return CircleAvatar(
                        backgroundColor: Colors.yellow[700],
                        child: Text(
                          '$num',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Matched users
                Expanded(
                  child: registeredUsers.isEmpty
                      ? const Center(
                          child: Text(
                            'No registered users yet',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: registeredUsers.length,
                          itemBuilder: (context, index) {
                            final user = registeredUsers[index];
                            final userNumbers = List<int>.from(user['numbers'] ?? []);
                            final matchedNumbers = userNumbers.where((num) => drawnNumbers.contains(num)).toList();
                            final matchedCount = matchedNumbers.length;

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              color: Colors.white70,
                              child: ListTile(
                                title: Text(user['name'] ?? 'Unknown'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Selected: ${userNumbers.join(', ')}'),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Matched ($matchedCount): ${matchedNumbers.join(', ')}',
                                      style: TextStyle(
                                        color: matchedCount > 0 ? Colors.green[700] : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
      },
    );
  }
}
