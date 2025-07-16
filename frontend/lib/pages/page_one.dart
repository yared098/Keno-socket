import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageOne extends StatefulWidget {
  final int duration;
  const PageOne({super.key, required this.duration});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List<int> displayedNumbers = [];
  Timer? timer;
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

    // Reset animation state if drawn numbers change
    if (drawnNumbers.isNotEmpty) {
      timer?.cancel();
      displayedNumbers.clear();
      currentIndex = 0;

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentIndex < drawnNumbers.length) {
          setState(() {
            displayedNumbers.add(drawnNumbers[currentIndex]);
            currentIndex++;
          });
        } else {
          timer.cancel();
        }
      });
    } else {
      // No drawn numbers, clear display
      setState(() {
        displayedNumbers.clear();
        currentIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildGrid() {
    final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 80,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemBuilder: (context, index) {
        final number = index + 1;
        final isDrawn = displayedNumbers.contains(number);

        return Container(
          decoration: BoxDecoration(
            color: isDrawn ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(color: isDrawn ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.duration;
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          'Drawn Numbers:',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: displayedNumbers.map((n) => Chip(label: Text(n.toString()))).toList(),
        ),
        const Divider(),
        Expanded(child: buildGrid()),
        const SizedBox(height: 8),
        Text('Page 1 duration: $duration seconds'),
        const SizedBox(height: 8),
      ],
    );
  }
}
