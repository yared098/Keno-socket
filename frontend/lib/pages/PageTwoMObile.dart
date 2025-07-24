import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageTwoMobile extends StatefulWidget {
  final int duration;
  const PageTwoMobile({super.key, required this.duration});

  @override
  State<PageTwoMobile> createState() => _PageTwoMobileState();
}

class _PageTwoMobileState extends State<PageTwoMobile> {
  final Set<String> _updatedUsers = {};

  /// Determines the prize based on how many numbers matched
  Map<String, dynamic> getPrize(int matched) {
    if (matched >= 6) return {'text': '🎁 100+ Birr', 'amount': 100};
    if (matched == 5 || matched == 4) return {'text': '🎁 50 Birr', 'amount': 50};
    if (matched == 3) return {'text': '🎁 20 Birr', 'amount': 20};
    if (matched == 2) return {'text': '🎁 10 Birr', 'amount': 10};
    if (matched == 1) return {'text': '🎁 5 Birr', 'amount': 5};
    return {'text': '❌ No Prize', 'amount': 0};
  }

  /// Updates balance on Firestore for a user
  Future<void> updateUserBalance(String deviceId, int prizeAmount) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('players').doc(deviceId);
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data();
        final currentBalance = (data?['balance'] ?? 0) as num;

        await docRef.update({
          'balance': currentBalance + prizeAmount,
          'last_win': prizeAmount,
          'last_updated': FieldValue.serverTimestamp(),
        });

        print('✅ Balance updated for $deviceId');
      }
    } catch (e) {
      print('❌ Error updating balance for $deviceId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, _) {
        final drawnNumbers = pageProvider.getDrawnNumbers;
        final registeredUsers = pageProvider.registeredUsers;
        

        Widget buildUserCard(Map<String, dynamic> user) {
          final userNumbers = List<int>.from(user['numbers'] ?? []);
          final matchedCount = userNumbers.where((num) => drawnNumbers.contains(num)).length;
          final prize = getPrize(matchedCount);
          final prizeAmount = prize['amount'] ?? 0;
          final prizeText = prize['text'] ?? '❌ No Prize';

          // Update balance only once per user
          final deviceId = user['name'];
          if (deviceId != null && prizeAmount > 0 && !_updatedUsers.contains(deviceId)) {
            _updatedUsers.add(deviceId);
            updateUserBalance(deviceId, prizeAmount);
          }

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
                      matchedCount > 0
                          ? '🏆 $matchedCount match'
                          : '❌ No match',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: matchedCount > 0
                            ? Colors.green.shade700
                            : Colors.red.shade400,
                      ),
                    ),
                    Text(
                      prizeText,
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
