import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Reservas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('reservations')
            .where('carOwnerId', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final reservations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservation =
                  reservations[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Reserva para o carro ${reservation['carId']}'),
                subtitle: Text(
                    'Data: ${reservation['date']} - Status: ${reservation['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _updateReservationStatus(
                            reservations[index].id, 'accepted');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _updateReservationStatus(
                            reservations[index].id, 'rejected');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateReservationStatus(
      String reservationId, String status) async {
    await _firestore.collection('reservations').doc(reservationId).update({
      'status': status,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva $status com sucesso.'),
      ),
    );
  }
}
