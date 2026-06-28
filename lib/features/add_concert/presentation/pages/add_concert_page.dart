import 'package:conciertos_app/features/concerts/data/services/concert_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/domain/entities/concert.dart';

class AddConcertPage extends StatefulWidget {
  const AddConcertPage({super.key});

  @override
  State<AddConcertPage> createState() => _AddConcertPageState();
}

class _AddConcertPageState extends State<AddConcertPage> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  DateTime? _selectedDate;

  final _artistController = TextEditingController();
  final _festivalController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  void _saveConcert() {
    final concert = Concert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      artist: _artistController.text.trim(),
      festival: _festivalController.text.trim(),
      city: '',
      date: _selectedDate!,
    );

    ConcertService.instance.addConcert(concert);

    if (!mounted) return;

    context.pop(true);
  }

  @override
  void dispose() {
    _artistController.dispose();
    _festivalController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '➕ Añadir concierto',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nuevo concierto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'Artista',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Introduce el nombre del artista';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _festivalController,
              decoration: const InputDecoration(
                labelText: 'Festival',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.festival),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_month),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona una fecha';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveConcert();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Concierto preparado 🎸')),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Guardar concierto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
