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
    double drawerWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sesión Administrador'),
        backgroundColor: Color.fromARGB(255, 255, 153, 189),
      ),
      drawer: SizedBox(
        width: drawerWidth, // Ajustar el ancho del drawer
        child: Drawer(
          child: Container(
            color: Color.fromARGB(255, 255, 153, 189),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text('T', style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'La Tata',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text(
                    'Compras',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Compra(title: 'Compras',)),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.local_shipping, color: Colors.black),
                //   title: Text(
                //     'Pedidos',
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               MyHomePage(title: 'Lista de Pedidos')),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.shopping_bag, color: Colors.black),
                //   title: Text(
                //     'Detalle de Ventas',
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => DetalleVenta()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.black),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.black),
                  ),
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
        ),
      ),
      body: body,
    );
  }
}
