import 'package:ecommerce_shopping_store/View/Buyer/home_screen/home_screen.dart';
import 'package:ecommerce_shopping_store/View/Buyer/orders_screen/orders_screen.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/buyer_address_bloc/buyer_address_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/order_bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ViewModel/Bloc/buyer_navigation_bloc/buyer_navigation_bloc.dart';
import '../../../ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import '../../../config/color/colors.dart';
import '../profile_screen/profile_screen.dart';


class BuyerMainScreen extends StatefulWidget {
  const BuyerMainScreen({super.key});

  @override
  State<BuyerMainScreen> createState() => _BuyerMainScreenState();
}

class _BuyerMainScreenState extends State<BuyerMainScreen> {

  late BuyerNavigationBloc _navigationBloc;
  late OrderBloc _orderBloc;
  late BuyerAddressBloc _addressBloc;

  final List<BottomNavigationBarItem> barItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopify),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _navigationBloc = BuyerNavigationBloc();
    _orderBloc = OrderBloc();
    _addressBloc = BuyerAddressBloc();
  }

  @override
  void dispose() {
    _navigationBloc.close();
    _orderBloc.close();
    _addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _navigationBloc),
        BlocProvider(create: (context) => _orderBloc),
        BlocProvider(create: (context) => _addressBloc),
      ],
      child: BlocBuilder<ThemeBloc,ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<BuyerNavigationBloc,BuyerNavigationState>(
                builder: (context, navigationState) {
                  return Scaffold(
                      backgroundColor: themeState.theme[appColors.appBGColor],
                      body: Column(
                        children: [
                          Expanded(
                            child: IndexedStack(
                              index: navigationState.selectedIndex,
                              children: [
                                BuyerHomeScreen(),
                                BuyerOrdersScreen(),
                                BuyerProfileScreen(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: navigationState.selectedIndex,
                        backgroundColor: themeState.theme[appColors.primaryColor],
                        unselectedItemColor: themeState.theme[appColors.accentColor],
                        selectedItemColor: themeState.theme[appColors.cardColor],
                        onTap: (index) {
                          context.read<BuyerNavigationBloc>().add(ChangeIndex(index: index));
                        },
                        items: barItems,
                      )
                  );
                }
            );
          }

      ),
    );
  }
}
