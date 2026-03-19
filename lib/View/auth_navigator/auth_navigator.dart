import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_shopping_store/View/views.dart';

import '../../ViewModel/Bloc/auth_bloc/auth_bloc.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
      previous.currentState != current.currentState &&
          current.currentState != AuthStates.Error &&
          current.currentState != AuthStates.Loading,
      builder: (context, state) {
        if (state.currentState == AuthStates.Authenticated) {
          if(state.userModel.role == PersonRole.buyer) {
            return BuyerMainScreen();
          }
          else if (state.userModel.role == PersonRole.seller) {
            return SellerMainScreen();
          }
          return LoginScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}