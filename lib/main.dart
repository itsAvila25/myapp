import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'admin/home.dart';
import 'cliente/floristeriatata.dart';

void main() {
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
        '/clientHome': (context) => FloristeriaTata(), // Utiliza FloristeriaTata aquí
      },
    );
  }
}
