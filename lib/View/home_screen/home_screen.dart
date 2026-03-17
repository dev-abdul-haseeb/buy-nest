import 'package:ecommerce_shopping_store/ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return ElevatedButton(onPressed: (){
                context.read<AuthBloc>().add(AuthLogOut());
              }, child: Icon(Icons.logout));
            }
          )
        ],
      ),
    );
  }
}
