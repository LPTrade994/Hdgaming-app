import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'category_drawer.dart';
import 'product_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initMessaging();
  runApp(const OverlaySupport.global(child: MyApp()));
}

Future<void> _initMessaging() async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.onMessage.listen(_showMessageOverlay);
}

void _showMessageOverlay(RemoteMessage message) {
  showOverlayNotification(
    (context) {
      final title = message.notification?.title ?? 'Notification';
      final body = message.notification?.body ?? '';
      return Material(
        color: Colors.black,
        child: SafeArea(
          bottom: false,
          child: ListTile(
            title: Text(title, style: const TextStyle(color: Colors.red)),
            subtitle: Text(body, style: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    },
    duration: const Duration(seconds: 3),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hdgaming App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _categories = [
    'Home',
    'Action',
    'Adventure',
    'RPG',
    'Sports',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CategoryDrawer(
        categories: _categories,
        onCategorySelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text(_categories[_selectedIndex]),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProductDetailPage(
                  imageUrls: [
                    'https://via.placeholder.com/300.png',
                    'https://via.placeholder.com/300.png?text=2',
                  ],
                  description: 'Questo è un prodotto di esempio.',
                  faq: [
                    'Domanda 1: risposta',
                    'Domanda 2: risposta',
                  ],
                ),
              ),
            );
          },
          child: const Text('Open Product'),
        ),
      ),
    );
  }
}
