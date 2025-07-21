import 'package:flutter/material.dart';

typedef OnEdit = void Function(int index);
typedef OnDelete = void Function(int index);
typedef OnPlay = void Function(int index);

class FavoriteNumberCard extends StatelessWidget {
  final List<int> numbers;
  final int index;
  final OnEdit onEdit;
  final OnDelete onDelete;
  final OnPlay onPlay;
    final Color? backgroundColor; // Add this line

  const FavoriteNumberCard({
    Key? key,
    required this.numbers,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onPlay,
        this.backgroundColor,  // Add this here too
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
       color: backgroundColor,  // Use it here
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Numbers display
            Row(
              children: numbers.map((n) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange, size: 20),
                  onPressed: () => onEdit(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => onDelete(index),
                ),
                ElevatedButton(
                  onPressed: () => onPlay(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.play_arrow, size: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
