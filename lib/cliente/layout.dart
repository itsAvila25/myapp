import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '../login_screen.dart';
import 'nuevaPQRS.dart';
import 'misPQRS.dart';
import 'pedidos.dart';
import 'detalleHistorialPedido.dart';

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
      title: 'PQRS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Floristeriatata(title: 'Floristeria la Tata'),
    );
  }
}

class Layout extends StatelessWidget {
  final Widget body;
  final String title;

  const Layout({Key? key, required this.body, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: _buildDrawer(context),
      body: body,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 255, 170, 222),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 170, 222),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('LA TATA'),
                  SizedBox(height: 10),
                  Image.network('https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Floristeria LA TATA',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Floristeriatata(title: 'Floristeria la Tata')),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Mis Pedidos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pedidos(title: 'Pedidos')),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.add,
              text: 'Nueva PQRS',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nuevaPQRS()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.list,
              text: 'Mis PQRS',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MisPQRS(title: 'Mis Pqrs',)),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.history,
              text: 'Historial de Pedidos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detalleHistorialPedido()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Cerrar Sesión',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}

class Floristeriatata extends StatelessWidget {
  final String title;

  const Floristeriatata({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      body: Center(
        child: Text('Bienvenido a Floristería LA TATA'),
      ),
    );
  }
}
