import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rentdriver/pages/userPage.dart';
import 'package:rentdriver/pages/carsPage.dart';
import 'package:rentdriver/pages/reservationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    HomePageContent(),
    CarsPage(),
    UserPage(),
    ReservationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Driver'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 132, 15, 153),
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(icon: Icons.directions_car, text: 'Cars'),
              GButton(icon: Icons.person, text: 'Profile'),
              GButton(icon: Icons.receipt, text: 'Reservations'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collectionGroup('cars').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final cars = snapshot.data!.docs;
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            var car = cars[index].data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                _showReservationModal(context, cars[index].id, car);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            car['model'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${car['model']} ${car['year']}'),
                          Text(car['city']),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('€${car['value']}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showReservationModal(
      BuildContext context, String carId, Map<String, dynamic> carData) {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserve ${carData['model']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
                child: Text('Selecione a Data de Reserva'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (selectedDate != null) {
                  _reserveCar(
                      context, carId, selectedDate!, carData['ownerId']);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, selecione uma data.'),
                    ),
                  );
                }
              },
              child: Text('Reservar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reserveCar(
      BuildContext context, String carId, DateTime date, String ownerId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime currentDate = DateTime.now();

      if (date.isBefore(currentDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Não é possível reservar para uma data que já passou.'),
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user.uid,
        'carId': carId,
        'carOwnerId': ownerId,
        'status': 'pending',
        'date': date,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reserva solicitada com sucesso.'),
        ),
      );
    }
  }
}
