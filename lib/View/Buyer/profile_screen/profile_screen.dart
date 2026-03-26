import 'package:ecommerce_shopping_store/ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/buyer_address_bloc/buyer_address_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/order_bloc/order_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import 'package:ecommerce_shopping_store/config/color/colors.dart';
import 'package:ecommerce_shopping_store/config/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/data_update_sheets/address_update_sheet.dart';
import '../../../config/data_update_sheets/profile_update_sheet.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {

  @override
  void initState() {
    context.read<OrderBloc>().add(GetNumberOfOrders(buyerId: FirebaseAuth.instance.currentUser!.uid));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          child: Text(authState.userModel.name.substring(0, 1)),
                        ),
                        const SizedBox(height: 12),
                        Text(authState.userModel.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(authState.userModel.email,
                            style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 12),

                        // Edit Profile Button
                        OutlinedButton.icon(
                          onPressed: () => showEditProfileSheet(context, authState),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),

                        BlocBuilder<BuyerAddressBloc, BuyerAddressState>(
                          builder: (context, addressState) {
                            return OutlinedButton.icon(
                              onPressed: () => showEditAddressSheet(context, addressState),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit Address'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            );
                          }
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Stats row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, orderState) {
                          return _StatItem(value: orderState.number_of_orders.toString(), label: 'Orders');
                        },
                      ),
                      const _StatItem(value: '3', label: 'Wishlist'),
                      const _StatItem(value: '5', label: 'Reviews'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 16),

                AppButton(
                  'Logout',
                  color: themeState.theme[appColors.primaryColor]!,
                  bgcolor: themeState.theme[appColors.errorColor]!,
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}