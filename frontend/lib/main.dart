import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/page_provider.dart';

// Import the pages
import 'pages/page_one.dart';
import 'pages/page_two.dart';
import 'pages/page_three.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Backend Controlled Pages',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PageControllerScreen(),
    );
  }
}

class PageControllerScreen extends StatelessWidget {
  const PageControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    final currentPage = pageProvider.currentPage;
    final duration = pageProvider.duration;

    Widget buildPage() {
      switch (currentPage) {
        case 1:
          return PageOne(duration: duration);
        case 2:
          return PageTwo(duration: duration);
        case 3:
          return PageThree(duration: duration);
        default:
          return const Center(child: Text('Unknown Page'));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Controlled Pages'),
      ),
      body: buildPage(),
    );
  }
}
