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
        final width = MediaQuery.of(context).size.width;
        final isDesktop = width > 900;

       Widget buildDrawnNumbersGrid() {
  return Container(
    width: isDesktop ? 280 : double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.green.shade800,
      borderRadius: BorderRadius.circular(12),
    ),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drawnNumbers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final num = drawnNumbers[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.yellow.shade700,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$num',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

        Widget buildUserCard(Map<String, dynamic> user) {
          final userNumbers = List<int>.from(user['numbers'] ?? []);
          final matchedNumbers = userNumbers.where((num) => drawnNumbers.contains(num)).toList();
          final matchedCount = matchedNumbers.length;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 14 : 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Selected: ${userNumbers.join(', ')}',
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Matched ($matchedCount): ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: matchedCount > 0 ? Colors.green.shade700 : Colors.red.shade700,
                          fontSize: isDesktop ? 12 : 15,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          matchedNumbers.isNotEmpty ? matchedNumbers.join(', ') : 'No matches',
                          style: TextStyle(
                            color: matchedCount > 0 ? Colors.green.shade700 : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: isDesktop ? 12 : 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.green.shade900,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: isDesktop
                  ? Row(
                      children: [
                        // Left: Drawn Numbers vertical list
                        buildDrawnNumbersGrid(),

                        const SizedBox(width: 16),

                        // Right: Registered Users list
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registered Players',
                                style: TextStyle(
                                  color: Colors.green.shade100,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: registeredUsers.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No registered users yet',
                                          style: TextStyle(color: Colors.white70, fontSize: 18),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: registeredUsers.length,
                                        itemBuilder: (context, index) => buildUserCard(registeredUsers[index]),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with duration
                        Text(
                          'Drawn Numbers - Duration: $duration seconds',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Drawn Numbers horizontal scroll
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: drawnNumbers.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final num = drawnNumbers[index];
                              return CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.yellow.shade700,
                                child: Text(
                                  '$num',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black38,
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Registered Users Title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Registered Players',
                            style: TextStyle(
                              color: Colors.green.shade100,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Users List or Empty message
                        Expanded(
                          child: registeredUsers.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No registered users yet',
                                    style: TextStyle(color: Colors.white70, fontSize: 18),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: registeredUsers.length,
                                  itemBuilder: (context, index) => buildUserCard(registeredUsers[index]),
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
