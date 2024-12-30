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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Travel Service'),
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
                  labelText: 'Travel Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter travel name';
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter route';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Departure Date'),
                subtitle: Text(departureDate?.toString() ?? 'Not selected'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => departureDate = date);
                  }
                },
              ),
              ListTile(
                title: const Text('Departure Time'),
                subtitle:
                    Text(departureTime?.format(context) ?? 'Not selected'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() => departureTime = time);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final travel = Travel(
                      namaTravel: nameController.text,
                      rute: routeController.text,
                      tanggalKeberangkatan: departureDate,
                      waktuKeberangkatan: departureTime?.format(context),
                      harga: double.tryParse(priceController.text),
                      kapasitas: int.tryParse(capacityController.text),
                    );

                    final db = await dbHelper.database;
                    await db.insert('travel', travel.toMap());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Travel Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
