import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carCityController = TextEditingController();
  final _carValueController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Carros'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getCarsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final cars = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    var car = cars[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${car['model']} ${car['year']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showEditCarModal(cars[index].id, car);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(car['city']),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '€${car['value']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Action for car status change
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: Text('Na garagem'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showAddCarModal();
            },
            child: Text('Adicionar Carro'),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getCarsStream() {
    User? user = _firebaseAuth.currentUser;
    return _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('cars')
        .snapshots();
  }

  void showAddCarModal() {
    _carModelController.clear();
    _carYearController.clear();
    _carCityController.clear();
    _carValueController.clear();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(
                  labelText: 'Modelo do Carro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carYearController,
                decoration: InputDecoration(
                  labelText: 'Ano do Carro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carCityController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carValueController,
                decoration: InputDecoration(
                  labelText: 'Valor Aluguer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: addCar,
                child: Text('Adicionar Carro'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditCarModal(String carId, Map<String, dynamic> carData) {
    _carModelController.text = carData['model'];
    _carYearController.text = carData['year'].toString();
    _carCityController.text = carData['city'];
    _carValueController.text = carData['value'].toString();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(
                  labelText: 'Modelo do Carro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carYearController,
                decoration: InputDecoration(
                  labelText: 'Ano do Carro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carCityController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _carValueController,
                decoration: InputDecoration(
                  labelText: 'Valor Aluguer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  editCar(carId);
                },
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addCar() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String uid = user.uid;
      await _firestore.collection('users').doc(uid).collection('cars').add({
        'model': _carModelController.text,
        'city': _carCityController.text,
        'year': int.parse(_carYearController.text),
        'value': int.parse(_carValueController.text),
        'ownerId': uid, // Salva o ID do proprietário do carro
      });

      _carModelController.clear();
      _carYearController.clear();
      _carCityController.clear();
      _carValueController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> editCar(String carId) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String uid = user.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('cars')
          .doc(carId)
          .update({
        'model': _carModelController.text,
        'city': _carCityController.text,
        'year': int.parse(_carYearController.text),
        'value': int.parse(_carValueController.text),
      });

      _carModelController.clear();
      _carYearController.clear();
      _carCityController.clear();
      _carValueController.clear();
      Navigator.pop(context);
    }
  }
}
