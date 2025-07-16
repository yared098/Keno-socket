// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/page_provider.dart';

// class PageOne extends StatefulWidget {
//   final int duration;
//   const PageOne({super.key, required this.duration});

//   @override
//   State<PageOne> createState() => _PageOneState();
// }

// class _PageOneState extends State<PageOne> {
//   List<int> displayedNumbers = [];
//   Timer? timer;
//   int currentIndex = 0;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

//     if (drawnNumbers.isNotEmpty) {
//       timer?.cancel();
//       displayedNumbers.clear();
//       currentIndex = 0;

//       timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (currentIndex < drawnNumbers.length) {
//           setState(() {
//             displayedNumbers.add(drawnNumbers[currentIndex]);
//             currentIndex++;
//           });
//         } else {
//           timer.cancel();
//         }
//       });
//     } else {
//       setState(() {
//         displayedNumbers.clear();
//         currentIndex = 0;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Widget buildGrid(BuildContext context, double width) {
//     final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

//     int crossAxisCount;
//     if (width > 1200) {
//       crossAxisCount = 15;
//     } else if (width > 800) {
//       crossAxisCount = 12;
//     } else if (width > 600) {
//       crossAxisCount = 10;
//     } else {
//       crossAxisCount = 8;
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: 80,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 6,
//         mainAxisSpacing: 6,
//       ),
//       itemBuilder: (context, index) {
//         final number = index + 1;
//         final isDrawn = displayedNumbers.contains(number);

//         return Material(
//           color: isDrawn ? Colors.green.shade600 : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(6),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(6),
//             onTap: () {},
//             hoverColor: Colors.green.shade400.withOpacity(0.5),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 number.toString(),
//                 style: TextStyle(
//                   color: isDrawn ? Colors.white : Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: width > 1200 ? 18 : 14,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildDrawnNumbersPanel(BuildContext context, double width) {
//     return Container(
//       width: width > 1200 ? 250 : 200,
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(left: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Drawn Numbers',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green.shade800,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: displayedNumbers
//                     .map((n) => Chip(
//                           label: Text(
//                             n.toString(),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           backgroundColor: Colors.green.shade400,
//                           labelStyle: const TextStyle(color: Colors.white),
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final duration = widget.duration;
//     final width = MediaQuery.of(context).size.width;
//     final isDesktopLayout = width > 800;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: isDesktopLayout
//           ? Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Left: grid expanded
//                 Expanded(child: buildGrid(context, width)),
//                 // Right: drawn numbers panel
//                 buildDrawnNumbersPanel(context, width),
//               ],
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Drawn Numbers',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green.shade800,
//                       ),
//                 ),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: displayedNumbers
//                       .map((n) => Chip(
//                             label: Text(
//                               n.toString(),
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             backgroundColor: Colors.green.shade400,
//                             labelStyle: const TextStyle(color: Colors.white),
//                           ))
//                       .toList(),
//                 ),
//                 const Divider(height: 32, thickness: 2),
//                 Expanded(child: buildGrid(context, width)),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Page 1 duration: $duration seconds',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();

    // Optional: configure TTS settings
    flutterTts.setSpeechRate(0.5); // slow rate
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

    final totalDurationInSeconds = widget.duration;
    final perNumberDuration = totalDurationInSeconds / drawnNumbers.length;

    Future<void> speakAndAnimate() async {
      for (int i = 0; i < drawnNumbers.length; i++) {
        final number = drawnNumbers[i];

        final stopwatch = Stopwatch()..start();

        // Speak the number
        await flutterTts.speak(number.toString());

        // Wait until speech is done
        await flutterTts.awaitSpeakCompletion(true);

        // Show the number on grid
        setState(() {
          displayedNumbers.add(number);
          currentIndex++;
        });

        stopwatch.stop();

        // Ensure consistent interval (speech + display)
        final remainingTime = perNumberDuration - stopwatch.elapsed.inMilliseconds / 1000.0;

        if (remainingTime > 0) {
          await Future.delayed(Duration(milliseconds: (remainingTime * 1000).round()));
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
    flutterTts.stop(); // stop any speech on dispose
    super.dispose();
  }

  Widget buildGrid(BuildContext context, double width) {
    final drawnNumbers = context.read<PageProvider>().getDrawnNumbers;

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
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final number = index + 1;
        final isDrawn = displayedNumbers.contains(number);

        return Material(
          color: isDrawn ? Colors.green.shade600 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {},
            hoverColor: Colors.green.shade400.withOpacity(0.5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: isDrawn ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: width > 1200 ? 18 : 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDrawnNumbersPanel(BuildContext context, double width) {
    return Container(
      width: width > 1200 ? 250 : 200,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drawn Numbers',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
  

  @override
  Widget build(BuildContext context) {
    final duration = widget.duration;
    final width = MediaQuery.of(context).size.width;
    final isDesktopLayout = width > 800;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: isDesktopLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: grid expanded
                Expanded(child: buildGrid(context, width)),
                // Right: drawn numbers panel
                buildDrawnNumbersPanel(context, width),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drawn Numbers',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
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
                const Divider(height: 32, thickness: 2),
                Expanded(child: buildGrid(context, width)),
                const SizedBox(height: 16),
                Text(
                  'Page 1 duration: $duration seconds',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}
