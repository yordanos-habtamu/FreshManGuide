import 'package:flutter/material.dart';
import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';
import 'package:flutter/services.dart';

class ArrangeEventScreen extends StatefulWidget {
  const ArrangeEventScreen({super.key});

  @override
  State<ArrangeEventScreen> createState() => _ArrangeEventScreenState();
}

class _ArrangeEventScreenState extends State<ArrangeEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _alumniGuestController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    _capacityController.dispose();
    _alumniGuestController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, simulate successful submission
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Event arranged successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Validator for Date & Time format (MM/DD/YYYY HH:MM)
  String? _validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter date and time';
    }
    final RegExp dateTimeRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}\s\d{2}:\d{2}$');
    if (!dateTimeRegExp.hasMatch(value)) {
      return 'Enter in format MM/DD/YYYY HH:MM (e.g., 05/05/2025 14:30)';
    }
    return null;
  }

  // Validator for Capacity (must be a positive integer)
  String? _validateCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter capacity';
    }
    final int? capacity = int.tryParse(value);
    if (capacity == null || capacity <= 0) {
      return 'Please enter a valid positive number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41 AM',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsScreen()),
                              );
                            },
                          ),
                          IconButton(
                              icon: const Icon(Icons.menu), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Placeholder Image
                  Container(
                    height: 150,
                    width: 300,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('Image Placeholder'),
                  ),
                  const SizedBox(height: 16.0),
                  // Form Fields
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTextFormField(
                          controller: _titleController,
                          label: 'Title',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a title'
                              : null,
                        ),
                        _buildTextFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a description'
                              : null,
                        ),
                        _buildTextFormField(
                          controller: _locationController,
                          label: 'Location',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a location'
                              : null,
                        ),
                        _buildTextFormField(
                          controller: _dateTimeController,
                          label: 'Date & Time',
                          hintText: 'e.g., 05/05/2025 14:30',
                          validator: _validateDateTime,
                        ),
                        _buildTextFormField(
                          controller: _capacityController,
                          label: 'Capacity',
                          validator: _validateCapacity,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        _buildTextFormField(
                          controller: _alumniGuestController,
                          label: 'Alumni Guest',
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter alumni guest'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87CEEB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Arrange'),
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
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
        validator: validator,
      ),
    );
  }
}
