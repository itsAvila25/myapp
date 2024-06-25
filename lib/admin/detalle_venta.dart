import 'package:flutter/material.dart';
import 'layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetalleVenta(),
    );
  }
}
class DetalleVenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Detalle de Venta',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            OrderCard(
              id: 1,
              pedidoId: 10,
              nombreProd: "Arreglo #1",
              cantidad: 2,
              impuesto: 14200,
              total: 15000,
              descripcion: 'Arreglo floral para Aniversarios',
              imageUrl:
                  'https://www.floristeriaangeluz.com/wp-content/uploads/2023/01/arreglo-floral-elegante-floristerA_as-en-cali-angeluz.jpg',
            ),
            OrderCard(
              id: 1,
              pedidoId: 11,
              nombreProd: "Arreglo #4",
              cantidad: 1,
              impuesto: 27000,
              total: 28000,
              descripcion: 'Arreglo para cumpleaños',
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9GzJWE_OhC3XdjHOEyopb6bfg4a8FRR5lOQ&s',
            ),
            OrderCard(
              id: 1,
              pedidoId: 12,
              nombreProd: "Arreglo #2",
              cantidad: 1,
              impuesto: 20000,
              total: 22000,
              descripcion: 'Arreglo para cumpleaños',
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9GzJWE_OhC3XdjHOEyopb6bfg4a8FRR5lOQ&s',
            ),
          ],
        ),
      ),
    );
  }
}


class OrderCard extends StatelessWidget {
  final int id;
  final int pedidoId;
  final String nombreProd;
  final int cantidad;
  final int impuesto;
  final int total;
  final String descripcion;
  final String imageUrl;

  const OrderCard({
    required this.id,
    required this.pedidoId,
    required this.nombreProd,
    required this.cantidad,
    required this.impuesto,
    required this.total,
    required this.descripcion,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descripcion,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Id pedido: $pedidoId',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    nombreProd,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Cantidad: $cantidad',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Impuesto: $impuesto',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total: $total',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
