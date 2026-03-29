import 'package:ecommerce_shopping_store/ViewModel/Bloc/buyer_address_bloc/buyer_address_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/seller_main_screen_bloc/seller_main_screen_bloc.dart';
import 'package:ecommerce_shopping_store/ViewModel/Bloc/seller_products_screen_bloc/seller_products_screen_bloc.dart';
import 'package:ecommerce_shopping_store/firebase_options.dart';
import 'package:ecommerce_shopping_store/repository/products_repository/seller_product_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import 'ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import 'config/color/colors.dart';
import 'config/routes/route_names.dart';
import 'config/routes/routes.dart';
final getIt = GetIt.instance;

void setupLocator() {
  // Register repositories
  getIt.registerLazySingleton<SellerProductRepository>(() => SellerProductRepository());
  //getIt.registerLazySingleton<SellerOrderRepository>(() => SellerOrderRepository());

  // Register BLoCs if needed
  getIt.registerFactory<ProductsBloc>(() => ProductsBloc(
    repository: getIt<SellerProductRepository>(),
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.authStateChanges().first;
  setupLocator();
  runApp(
    MyApp(
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),

        BlocProvider(create: (context) => AuthBloc()),

        BlocProvider(create: (_)=>SellerMainNavBloc()),

        BlocProvider(create: (_)=>BuyerAddressBloc()),
        BlocProvider(create: (_)=>getIt<ProductsBloc>())

      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: RouteNames.splashScreen,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                    color: themeState.isDark ? themeState.theme[appColors.accentColor] : themeState.theme[appColors.primaryColor]
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(
                    color: themeState.isDark ? themeState.theme[appColors.accentColor] : themeState.theme[appColors.primaryColor]
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}