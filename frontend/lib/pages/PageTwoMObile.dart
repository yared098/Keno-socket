import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageTwoMobile extends StatelessWidget {
  final int duration;
  const PageTwoMobile({super.key, required this.duration});

  String getPrize(int matched) {
    if (matched >= 6) return '🎁 100+ Birr';
    if (matched == 5 || matched == 4) return '🎁 50 Birr';
    if (matched == 3) return '🎁 20 Birr';
    if (matched == 2) return '🎁 10 Birr';
    if (matched == 1) return '🎁 5 Birr';
    return '❌ No Prize';
  }

  @override
Widget build(BuildContext context) {
  return Consumer<PageProvider>(
    builder: (context, pageProvider, _) {
      final drawnNumbers = pageProvider.getDrawnNumbers;
      final registeredUsers = pageProvider.registeredUsers;

      Widget buildUserCard(Map<String, dynamic> user) {
        final userNumbers = List<int>.from(user['numbers'] ?? []);
        final matchedCount =
            userNumbers.where((num) => drawnNumbers.contains(num)).length;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFFFAFAFA), Color(0xFFF1F8E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '🎯 Selected: ${userNumbers.join(', ')}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    matchedCount > 0 ? '🏆 $matchedCount match' : '❌ No match',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: matchedCount > 0
                          ? Colors.green.shade700
                          : Colors.red.shade400,
                    ),
                  ),
                  Text(
                    getPrize(matchedCount),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: matchedCount > 0
                          ? Colors.orange.shade800
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎱 Drawn Numbers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: drawnNumbers.map((num) {
                        return CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.amber.shade600,
                          child: Text(
                            '$num',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '🧑‍🤝‍🧑 Registered Players (${registeredUsers.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: registeredUsers.isEmpty
                        ? const Center(
                            child: Text(
                              'No registered users yet.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: registeredUsers.length,
                            itemBuilder: (context, index) =>
                                buildUserCard(registeredUsers[index]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}