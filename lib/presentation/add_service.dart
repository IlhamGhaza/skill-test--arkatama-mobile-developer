import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/datasource/travel.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final routeController = TextEditingController();
  DateTime? departureDate;
  TimeOfDay? departureTime;
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final dbHelper = DatabaseHelper();

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
  void dispose() {
    nameController.dispose();
    routeController.dispose();
    priceController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Add Service',
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
                                  labelText: 'Travel Name',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter travel service name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Travel name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: routeController,
                                decoration: const InputDecoration(
                                  labelText: 'Route',
                                  border: OutlineInputBorder(),
                                  hintText:
                                      'Enter travel route (e.g., Jakarta - Bandung)',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Route is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() => departureDate = date);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Departure Date',
                                    border: OutlineInputBorder(),
                                    errorText: departureDate == null
                                        ? 'Please select departure date'
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(departureDate
                                              ?.toString()
                                              .split(' ')[0] ??
                                          'Select Date'),
                                      Icon(Icons.calendar_today),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    setState(() => departureTime = time);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Departure Time',
                                    border: OutlineInputBorder(),
                                    errorText: departureTime == null
                                        ? 'Please select departure time'
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(departureTime?.format(context) ??
                                          'Select Time'),
                                      Icon(Icons.access_time),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Price',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter price in IDR',
                                  prefixText: 'Rp ',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Price is required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Price must be greater than 0';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: capacityController,
                                decoration: const InputDecoration(
                                  labelText: 'Capacity',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter passenger capacity',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Capacity is required';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (int.parse(value) <= 0) {
                                    return 'Capacity must be greater than 0';
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        if (departureDate == null) {
                                          showErrorSnackBar(
                                              'Please select departure date');
                                          return;
                                        }

                                        if (departureTime == null) {
                                          showErrorSnackBar(
                                              'Please select departure time');
                                          return;
                                        }

                                        try {
                                          final travel = Travel(
                                            namaTravel: nameController.text,
                                            rute: routeController.text,
                                            tanggalKeberangkatan: departureDate,
                                            waktuKeberangkatan:
                                                departureTime?.format(context),
                                            harga: double.parse(
                                                priceController.text),
                                            kapasitas: int.parse(
                                                capacityController.text),
                                          );

                                          final db = await dbHelper.database;
                                          await db.insert(
                                              'travel', travel.toMap());

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Travel service added successfully'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        } catch (e) {
                                          showErrorSnackBar(
                                              'Error adding service: $e');
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
                                            'Add Service',
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
