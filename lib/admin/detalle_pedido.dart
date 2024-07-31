import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetallePedido extends StatelessWidget {
  final int pedidoId;

  DetallePedido({required this.pedidoId});

  Future<Map<String, dynamic>> _fetchDetalle() async {
    try {
      final response = await http.get(Uri.parse('https://prueba-floristeria-production.up.railway.app/api/pedido/detalle/$pedidoId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar los detalles del pedido');
      }
    } catch (error) {
      print("Error al cargar los detalles del pedido: $error");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Pedido'),
        backgroundColor: Color.fromARGB(255, 228, 166, 188),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDetalle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron detalles del pedido'));
          } else {
            final pedido = snapshot.data!;
            final detalles = pedido['detalles'] as List<dynamic>;
            return ListView.builder(
              itemCount: detalles.length,
              itemBuilder: (context, index) {
                final detalle = detalles[index];
                // Asignar imágenes basadas en el índice
                String imagePath;
                if (index == 0) {
                  imagePath = 'assets/images/arreglo_1.jpg';
                } else if (index == 1) {
                  imagePath = 'assets/images/arreglo_2';
                } else {
                  imagePath = 'assets/images/default.jpg'; // Imagen por defecto
                }

                // Estilo de texto para el nombre del producto
                TextStyle productNameStyle = TextStyle(
                  fontWeight: FontWeight.bold, // Negrita
                  fontSize: 16,
                );

                return Card(
                  color: const Color.fromARGB(255, 240, 133, 169), 
                  elevation: 4, 
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margen
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Producto: ${detalle['producto']['nombre']}',
                              style: productNameStyle,
                            ),
                            Text('Cantidad: ${detalle['cantidad']}'),
                            Text('Precio: ${detalle['precio']}'),
                            Text('Impuesto: ${detalle['impuesto']}'), 
                          ],
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
