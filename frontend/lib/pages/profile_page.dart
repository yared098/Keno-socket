import 'dart:math';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int randomKeno;

  @override
  void initState() {
    super.initState();
    randomKeno = generateRandomKeno();
  }

  int generateRandomKeno() {
    final random = Random();
    return random.nextInt(80) + 1; // 1 to 80
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              "Keno #$randomKeno",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please wait...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            const Text(
              "Maybe a server issue",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  randomKeno = generateRandomKeno();
                });
              },
              child: const Text("Retry"),
            )
          ],
        ),
      ),
    );
  }
}
