import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'admin/home.dart';
import 'cliente/floristeriatata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cliente/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/adminDashboard': (context) => AdminDashboardScreen(),
        '/clientHome': (context) => FloristeriaTata(), 
      },
    );
  }
}