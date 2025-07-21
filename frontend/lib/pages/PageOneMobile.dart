import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../providers/page_provider.dart';

class PageOneMobile extends StatefulWidget {
  final int duration;
  const PageOneMobile({super.key, required this.duration});

  @override
  State<PageOneMobile> createState() => _PageOneState();
}

class _PageOneState extends State<PageOneMobile> {
  List<int> displayedNumbers = [];
  Timer? timer;
  int currentIndex = 0;
  late FlutterTts flutterTts;
  bool isMuted = true;  // <-- sound state

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

    if (drawnNumbers.isNotEmpty) {
      timer?.cancel();
      displayedNumbers.clear();
      currentIndex = 0;

      final perNumberDuration = widget.duration / drawnNumbers.length;

      Future<void> speakAndAnimate() async {
        for (int i = 0; i < drawnNumbers.length; i++) {
          final number = drawnNumbers[i];
          final stopwatch = Stopwatch()..start();

          if (!isMuted) {
            await flutterTts.speak(number.toString());
            await flutterTts.awaitSpeakCompletion(true);
          }

          setState(() {
            displayedNumbers.add(number);
            currentIndex++;
          });

          stopwatch.stop();
          final remaining = perNumberDuration - stopwatch.elapsed.inMilliseconds / 1000.0;
          if (remaining > 0) {
            await Future.delayed(Duration(milliseconds: (remaining * 1000).round()));
          }
        }
      }

      speakAndAnimate();
    } else {
      setState(() {
        displayedNumbers.clear();
        currentIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      if (isMuted) {
        flutterTts.stop();
      }
    });
  }

  Widget buildGrid(double width) {
    int crossAxisCount;
    if (width > 1200) {
      crossAxisCount = 15;
    } else if (width > 800) {
      crossAxisCount = 12;
    } else if (width > 600) {
      crossAxisCount = 10;
    } else {
      crossAxisCount = 8;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 80,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final number = index + 1;
        final isDrawn = displayedNumbers.contains(number);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isDrawn ? Colors.green.shade700 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isDrawn
                ? [BoxShadow(color: Colors.green.shade300, blurRadius: 4, offset: Offset(0, 2))]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: width > 1200 ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isDrawn ? Colors.white : Colors.black87,
            ),
          ),
        );
      },
    );
  }

  Widget buildDrawnNumbersPanel(double width) {
    return Container(
      width: width > 1200 ? 260 : 220,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎱 Drawn Numbers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayedNumbers
                    .map((n) => Chip(
                          label: Text(
                            n.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green.shade400,
                          labelStyle: const TextStyle(color: Colors.white),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooterInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.amber.shade700,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.amber.shade200, blurRadius: 6)],
          ),
          child: const Text(
            '🎉 Win up to 25,000 ETB now!',
            style: TextStyle(
              color: Color.fromARGB(255, 106, 4, 116),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top bar with title and mute/unmute button in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎱 Drawn Numbers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.yellow,
                      size: 28,
                    ),
                    onPressed: toggleMute,
                    tooltip: isMuted ? 'Unmute Sound' : 'Mute Sound',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: buildGrid(width)),
                          buildDrawnNumbersPanel(width),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(child: buildGrid(width)),
                          const SizedBox(height: 16),
                          buildFooterInfo(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
