import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detallePQRS.dart';
import 'layout.dart';
import 'package:intl/intl.dart';

class MisPQRS extends StatefulWidget {
  final String title;

  const MisPQRS({Key? key, required this.title}) : super(key: key);

  @override
  _MisPQRSState createState() => _MisPQRSState();
}

class _MisPQRSState extends State<MisPQRS> {
  final CollectionReference _pqrsCollection =
      FirebaseFirestore.instance.collection('pqrs');

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: widget.title,
      body: Column(
        children: [
          Image.network(
            'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _pqrsCollection
                  .orderBy('fecha_envio', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Card(
                        color: const Color.fromARGB(255, 255, 170, 222),
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        child: ListTile(
                          title: Text('ID: ${documentSnapshot['id']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estado: ${documentSnapshot['estado']}'),
                              Text(
                                  'Fecha de Envío: ${_formatDateTime(documentSnapshot['fecha_envio'].toDate())}'),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                ElevatedButton(
                                  child: const Text("Ver PQRS"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 102, 204),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detallePQRS(
                                              pqrs: documentSnapshot)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
