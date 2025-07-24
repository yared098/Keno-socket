import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileShowWidget extends StatelessWidget {
  final String? userName;
  final String? phone;
  final String? deviceId;
  final double? balance;
  final VoidCallback? onWithdraw;
  final VoidCallback? onDeposit;

  const ProfileShowWidget({
    Key? key,
    required this.userName,
    this.phone,
    required this.deviceId,
    this.balance,
    this.onWithdraw,
    this.onDeposit,
  }) : super(key: key);

  Future<void> _clearSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 🔥 This removes all stored data
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name row
            // ElevatedButton(
            //   onPressed: () async {
            //     await _clearSharedPrefs();
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('User data cleared!')),
            //     );
            //     // Optional: Navigate to registration page again
            //   },
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            //   child: const Text('Clear User Data'),
            // ),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  userName ?? 'Unknown',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Phone row (conditionally shown)
            if (phone != null && phone!.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    phone!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Balance row with buttons
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Balance  ${balance?.toStringAsFixed(2)} ETB',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),

                const Spacer(),

                // Withdraw button
                IconButton(
                  onPressed: onWithdraw,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  tooltip: 'Withdraw',
                ),

                // Deposit button
                IconButton(
                  onPressed: onDeposit,
                  icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  tooltip: 'Deposit',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Device ID row
            Row(
              children: [
                const Icon(Icons.devices_other, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    deviceId ?? "Loading...",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
