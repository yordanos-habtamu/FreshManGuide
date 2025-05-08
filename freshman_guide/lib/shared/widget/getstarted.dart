import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';

class GetStartedScreen extends StatefulWidget {
  final String userType;

  const GetStartedScreen({super.key, required this.userType});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _yearController = TextEditingController();
  final _departmentController = TextEditingController();
  String? _selectedGender;
  bool _hasVisualDisability = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _yearController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    final dobRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dobRegex.hasMatch(value)) {
      return 'Enter a valid date in DD/MM/YYYY format';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year is required';
    }
    final year = int.tryParse(value);
    if (year == null || year < 2020) {
      return 'Enter a valid year (2020 or later)';
    }
    return null;
  }

  String? _validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Department is required';
    }
    if (value.length < 3) {
      return 'Department must be at least 3 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Let's Get Started",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF42A5F5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildTextField(
                            'First Name',
                            _firstNameController,
                            validator: (value) => _validateName(value, 'First Name'),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Last Name',
                            _lastNameController,
                            validator: (value) => _validateName(value, 'Last Name'),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Date of Birth',
                            _dobController,
                            validator: _validateDob,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Year',
                            _yearController,
                            keyboardType: TextInputType.number,
                            validator: _validateYear,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Department',
                            _departmentController,
                            validator: _validateDepartment,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildRadioButton('Male'),
                              const SizedBox(width: 20),
                              _buildRadioButton('Female'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _hasVisualDisability,
                                onChanged: (value) {
                                  setState(() {
                                    _hasVisualDisability = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF42A5F5),
                              ),
                              Text(
                                'Visual Disability',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPageIndicator(isActive: false),
                      const SizedBox(width: 10),
                      _buildPageIndicator(isActive: true),
                      const SizedBox(width: 10),
                      _buildPageIndicator(isActive: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_selectedGender == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a gender')),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(userType: widget.userType),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF42A5F5),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
        mini: true,
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black54,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF42A5F5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedGender,
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          activeColor: const Color(0xFF42A5F5),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator({required bool isActive}) {
    return Container(
      width: isActive ? 30 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF42A5F5) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}