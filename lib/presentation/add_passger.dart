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

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset('assets/images/Header-BG.png',
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Container(
                      width: 45,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 120),
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Add Passenger',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your full name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
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
                                  hintText: 'Enter your email address',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your phone number',
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your complete address',
                                ),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
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
                                    child: Text(
                                        '${travel.namaTravel} - ${travel.rute}'),
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 131,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(0xffC3D3E2)),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Inter'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (selectedTravel == null) {
                                            showErrorSnackBar(
                                                'Please select a travel service');
                                            return;
                                          }

                                          final passenger = Passenger(
                                            nama: nameController.text,
                                            email: emailController.text,
                                            noTelepon: phoneController.text,
                                            alamat: addressController.text,
                                            travelId: selectedTravel?.id,
                                          );

                                          try {
                                            final db = await dbHelper.database;
                                            await db.insert(
                                                'penumpang', passenger.toMap());
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Passenger added successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            showErrorSnackBar(
                                                'Failed to add passenger. Please try again.');
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xff212143),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Add Passenger',
                                            style: TextStyle(
                                              color: Color(0xffF5F5F5),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
