import 'package:flutter/material.dart';
import 'detalle_venta.dart';
import 'home.dart';
import 'pedidos.dart';
import '../login_screen.dart';
import 'compra.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  CommonScaffold({required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sesión Administrador',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFB3C7D6), // Color pastel neutro
        elevation: 0,
      ),
      drawer: SizedBox(
        width: drawerWidth,
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF6F2F1), // Suave blanco arena
                  Color(0xFFD9E4EC), // Azul pastel neutro
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFB3C7D6), // Fondo pastel
                        child: Text(
                          'T',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'La Tata',
                        style: TextStyle(
                          color: Color(0xFF4A5568), // Gris neutro oscuro
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                _drawerItem(
                  context,
                  icon: Icons.home,
                  text: 'Inicio',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminDashboardScreen()),
                    );
                  },
                ),
                _drawerItem(
                  context,
                  icon: Icons.shopping_bag,
                  text: 'Compras',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Compra(title: 'Compras')),
                    );
                  },
                ),
                _drawerItem(
                  context,
                  icon: Icons.exit_to_app,
                  text: 'Cerrar sesión',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _drawerItem(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xFF4A5568), // Gris neutro oscuro
        size: 28,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: Color(0xFF4A5568), // Gris neutro oscuro
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      hoverColor: Color(0xFFE5ECF2), // Azul muy claro al interactuar
    );
  }
}
