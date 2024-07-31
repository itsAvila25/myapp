import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class detallePQRS extends StatelessWidget {
  final DocumentSnapshot pqrs;

  const detallePQRS({Key? key, required this.pqrs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp fechaEnvioTimestamp = pqrs['fecha_envio'];
    DateTime fechaEnvio = fechaEnvioTimestamp.toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de PQRS'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color.fromARGB(255, 255, 170, 222),
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${pqrs['id']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estado: ${pqrs['estado']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha de Envío: ${_formatDateTime(fechaEnvio)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${pqrs['tipo']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Motivo: ${pqrs['motivo']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Descripción: ${pqrs['descripcion']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Formato de fecha personalizado
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
