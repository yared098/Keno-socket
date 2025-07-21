import 'dart:math';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late int randomKeno;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<int> match4 = [5, 10, 15, 20];
  final List<int> match3 = [25, 30, 35];
  final List<int> match2 = [40, 45];
  final List<int> match1 = [50];

  late List<int> allMatchNumbers;

  @override
  void initState() {
    super.initState();

    allMatchNumbers = [...match4, ...match3, ...match2, ...match1];
    randomKeno = generateRandomKeno();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  int generateRandomKeno() {
    final random = Random();
    return allMatchNumbers[random.nextInt(allMatchNumbers.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildMatchLevel(String title, List<int> numbers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: numbers.map((num) {
              final isMatch = num == randomKeno;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isMatch ? Colors.amber : Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Text(
                    num.toString(),
                    style: TextStyle(
                      color: isMatch ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A00E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.stars, size: 50, color: Colors.yellow),
                      Text(
                        "Keno #$randomKeno",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        allMatchNumbers.contains(randomKeno)
                            ? "🎉 Matched Prize! 🎉"
                            : "💥 No Win",
                        style: TextStyle(
                          color: allMatchNumbers.contains(randomKeno)
                              ? Colors.amber
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Reverse Match Rewards
              buildMatchLevel("Match 4 ➜ 25,000", match4),
              buildMatchLevel("Match 3 ➜ 10,000", match3),
              buildMatchLevel("Match 2 ➜ 5,000", match2),
              buildMatchLevel("Match 1 ➜ 2,000", match1),

              const SizedBox(height: 24),
              const Divider(color: Colors.white24, thickness: 1),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "🎁 Prize List 🎁",
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("✅ Match 4 ➜ 25,000", style: TextStyle(color: Colors.white)),
                    Text("✅ Match 3 ➜ 10,000", style: TextStyle(color: Colors.white)),
                    Text("✅ Match 2 ➜ 5,000", style: TextStyle(color: Colors.white)),
                    Text("✅ Match 1 ➜ 2,000", style: TextStyle(color: Colors.white)),
                    Text("❌ Match 0 ➜ 0", style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Help & Info
              Container(
                width: double.infinity,
                color: Colors.white12,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Center(
                  child: Text(
                    "📞 Help & Info: +251 911 000 000",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
