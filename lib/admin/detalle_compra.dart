import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalleCompra extends StatelessWidget {
  final int id;

  DetalleCompra({required this.id});

  Future<Map<String, dynamic>> _fetchDetalle() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/compra/detalle/$id'));
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
        title: Text('Detalle de la Compra'),
        backgroundColor: Color(0xFFB3C7D6),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDetalle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron detalles de la compra'));
          } else {
            final pedido = snapshot.data!;
            final detalles = pedido['detalles'] as List<dynamic>;
            return ListView.builder(
              itemCount: detalles.length,
              itemBuilder: (context, index) {
                final detalle = detalles[index];
                final insumo = detalle['insumo']; // Obtienes el objeto insumo
                final insumoNombre = insumo['nombre']; // Accedes al nombre del insumo
                final insumoColor = insumo['color']; // Accedes al color del insumo
                final categoria = insumo['categoria_insumo']; // Accedes a la categoría del insumo

                return Card(
                  color: Color(0xFFF7C5A8),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margen
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoria: ${categoria['nombre']}'), // Muestra la categoría
                            Text('Insumo: $insumoNombre - $insumoColor'), // Muestra el nombre y el color
                            Text('Cantidad: ${detalle['cantidad']}'),
                            Text('Costo unitario: ${detalle['costo_unitario']}'),
                            Text('Subtotal: ${detalle['subtotal']}'),
                          ],
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
