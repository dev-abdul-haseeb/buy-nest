import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ViewModel/Bloc/auth_bloc/auth_bloc.dart';

void showEditProfileSheet(BuildContext context, AuthState authState) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: authState.userModel.name);
  final cnicController = TextEditingController(text: authState.userModel.cnic.toString());
  final phoneController = TextEditingController(text: authState.userModel.phone.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              _ProfileTextField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Name cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _ProfileTextField(
                controller: cnicController,
                label: 'CNIC',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'CNIC cannot be empty';
                  if (value.trim().length != 13) return 'CNIC must be exactly 13 digits';
                  if (!RegExp(r'^\d{13}$').hasMatch(value.trim())) return 'CNIC must contain numbers only';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _ProfileTextField(
                controller: phoneController,
                label: 'Phone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Phone cannot be empty';
                  if (!RegExp(r'^\d{10,13}$').hasMatch(value.trim())) return 'Phone must be 10–13 digits';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(UpdateProfile(
                        name: nameController.text.trim(),
                        cnic: cnicController.text.trim(),
                        phone: phoneController.text.trim(),
                      ));
                      Navigator.pop(sheetContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Reusable text field for the edit sheet
class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}