import 'package:ecommerce_shopping_store/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import 'ViewModel/Bloc/main_screen_bloc/main_screen_bloc.dart';
import 'ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import 'config/color/colors.dart';
import 'config/routes/route_names.dart';
import 'config/routes/routes.dart';

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

  runApp(
    const MyApp(),
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
        BlocProvider(
          create: (_) => MainNavBloc(),
        )

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