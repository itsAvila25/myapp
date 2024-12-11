import 'package:flutter/material.dart';
import 'layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floristería La Tata',
      theme: ThemeData(
        primaryColor: Color(0xFFA8D5BA), // Verde pastel
        scaffoldBackgroundColor: Color(0xFFF7F3E9), // Fondo beige claro
        fontFamily: 'Arial',
      ),
      home: AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Sección de administración',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Encabezado decorativo
            _buildHeader(),
            SizedBox(height: 20),
            // Cuatro recuadros con iconos decorativos
            _buildDecorativeGrid(),
            SizedBox(height: 20),
            // Pie decorativo
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // Encabezado decorativo
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFA8D5BA), // Fondo verde pastel
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.local_florist,
              size: 50,
              color: Color(0xFF4CAF50), // Verde oscuro
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Bienvenido, Administrador',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Gestiona las compras de tu floristería',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Cuatro recuadros decorativos con iconos
  Widget _buildDecorativeGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDecorativeCard(
                icon: Icons.local_shipping, // Ícono de envíos
                label: 'Envíos',
                color: Color(0xFFF7C5A8), // Rosa pastel
              ),
              _buildDecorativeCard(
                icon: Icons.verified, // Ícono de calidad
                label: 'Calidad',
                color: Color(0xFFA8D5BA), // Verde pastel
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDecorativeCard(
                icon: Icons.attach_money, // Ícono de precio
                label: 'Economico',
                color: Color(0xFFF2E8CF), // Amarillo suave
              ),
              _buildDecorativeCard(
                icon: Icons.speed, // Ícono de efectividad
                label: 'Efectividad',
                color: Color(0xFFD9E4EC), // Rosa pastel
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Pie decorativo
  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        'Floristería La Tata',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
