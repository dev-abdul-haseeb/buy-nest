import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ViewModel/Bloc/buyer_address_bloc/buyer_address_bloc.dart';

void showEditAddressSheet(BuildContext context, BuyerAddressState addressState) {
  final formKey = GlobalKey<FormState>();
  final houseController = TextEditingController(text: addressState.addressModel.house);
  final streetController = TextEditingController(text: addressState.addressModel.street);
  final cityController = TextEditingController(text: addressState.addressModel.city);
  final countryController = TextEditingController(text: addressState.addressModel.country);

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

              const Text('Edit Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              _ProfileTextField(
                controller: houseController,
                label: 'House',
                icon: Icons.person_outline,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _ProfileTextField(
                controller: streetController,
                label: 'Street',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Street cannot be empty';
                },
              ),
              const SizedBox(height: 12),
              _ProfileTextField(
                controller: cityController,
                label: 'City',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'City cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _ProfileTextField(
                controller: countryController,
                label: 'Country',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Country cannot be empty';
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<BuyerAddressBloc>().add(UpdateBuyerAddress(
                        house: houseController.text.trim(),
                        street: streetController.text.trim(),
                        city: cityController.text.trim(),
                        country: countryController.text.trim()
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