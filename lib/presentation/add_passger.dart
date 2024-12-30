import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/datasource/passager.dart';
import '../data/datasource/travel.dart';


class AddPassger extends StatefulWidget {
  const AddPassger({super.key});

  @override
  State<AddPassger> createState() => _AddPassgerState();
}

class _AddPassgerState extends State<AddPassger> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dbHelper = DatabaseHelper();

  Travel? selectedTravel;
  List<Travel> availableTravel = [];

  @override
  void initState() {
    super.initState();
    loadTravelServices();
  }

  Future<void> loadTravelServices() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('travel');
    setState(() {
      availableTravel = List.generate(maps.length, (i) {
        return Travel.fromMap(maps[i]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Passenger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Travel>(
                value: selectedTravel,
                decoration: const InputDecoration(
                  labelText: 'Select Travel Service',
                  border: OutlineInputBorder(),
                ),
                items: availableTravel.map((Travel travel) {
                  return DropdownMenuItem<Travel>(
                    value: travel,
                    child: Text('${travel.namaTravel} - ${travel.rute}'),
                  );
                }).toList(),
                onChanged: (Travel? value) {
                  setState(() {
                    selectedTravel = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a travel service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final passenger = Passenger(
                      nama: nameController.text,
                      email: emailController.text,
                      noTelepon: phoneController.text,
                      alamat: addressController.text,
                      travelId: selectedTravel?.id,
                    );

                    final db = await dbHelper.database;
                    await db.insert('penumpang', passenger.toMap());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Passenger'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
