import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import '../../../ViewModel/Bloc/obscure_text/obscure_text_bloc.dart';
import '../../../ViewModel/Bloc/theme_bloc/theme_bloc.dart';
import '../../../config/color/colors.dart';
import '../../../config/components/button.dart';
import '../../../config/components/icons.dart';
import '../../../config/enums/enums.dart';
import '../../../config/flash_bar/flash_bar.dart';
import '../../../config/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late ObscureTextBloc _obscureTextBloc;

  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> nodes = [
    FocusNode(), // Email: 0
    FocusNode(), // Password: 1
  ];

  final List<TextInputType> inputTypes = [
    TextInputType.emailAddress,
    TextInputType.text,
  ];

  final List<TextCapitalization> capitalizations = [
    TextCapitalization.none,
    TextCapitalization.none,
  ];

  final List<String> labels = [
    'Email',
    'Password',
  ];

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validatorForIndex(int index, String? value) {
    switch (index) {
      case 0: return _validateEmail(value);
      case 1: return _validatePassword(value); // Password
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _obscureTextBloc = ObscureTextBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nodes[0]);
    });
    context.read<AuthBloc>().add(ClearAuthFields());
  }

  @override
  void dispose() {
    for (final node in nodes) node.dispose();
    _obscureTextBloc.close();
    super.dispose();
  }

  AuthEvent _eventForIndex(int index, String value) {
    switch (index) {
      case 0: return EmailChanged(email: value);
      case 1: return PasswordChanged(password: value);
      default: throw RangeError('Index $index out of range');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _obscureTextBloc,
      child: BlocBuilder<ThemeBloc,ThemeState>(
          builder: (context, themeState) {
            return Scaffold(
              body: BlocListener<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                previous.currentState == AuthStates.Loading &&
                    current.currentState != AuthStates.Loading,
                listener: (context, state) {
                  final isSuccess = state.currentState == AuthStates.Authenticated;
                  final message =
                  (state.message.isNotEmpty ?? false) ? state.message : (isSuccess ? 'Login successful!' : 'Login failed.');
                  showFlashbar(context, message, isSuccess);
                },
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? 400 : screenWidth * 0.06,
                      vertical: screenHeight * 0.015,
                    ),
                    children: [

                      ...List.generate(nodes.length, (index) {
                        final isPassword = labels[index] == 'Password';
                        return BlocBuilder<ObscureTextBloc, ObscureTextState>(
                          buildWhen: (previous, current) =>
                          isPassword && previous.obscureText != current.obscureText,
                          builder: (context, obscureState) {
                            return Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.02),
                              child: TextFormField(
                                keyboardType: inputTypes[index],
                                focusNode: nodes[index],
                                textCapitalization: capitalizations[index],
                                obscureText: isPassword ? obscureState.obscureText : false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => _validatorForIndex(index, value),
                                style: TextStyle(
                                  color: themeState.isDark
                                      ? themeState.theme[appColors.accentColor]
                                      : themeState.theme[appColors.textPrimaryColor],
                                ),
                                decoration: InputDecoration(
                                  hintText: labels[index],
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  suffixIcon: isPassword
                                      ? IconButton(
                                    icon: Icon(obscureState.obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => context
                                        .read<ObscureTextBloc>()
                                        .add(ToggleObscure()),
                                  )
                                      : null,
                                  prefixIcon: AppIcons.appIcon[labels[index]],
                                  prefixIconColor: themeState.theme[appColors.primaryColor],
                                ),
                                onChanged: (newValue) => context
                                    .read<AuthBloc>()
                                    .add(_eventForIndex(index, newValue)),
                                onFieldSubmitted: (_) {
                                  if (index == nodes.length - 1) {
                                    FocusScope.of(context).unfocus();
                                  } else {
                                    FocusScope.of(context).requestFocus(nodes[index + 1]);
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }),


                      SizedBox(height: screenHeight * 0.01),
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, RouteNames.signUpScreen,
                        );
                      }, child: Text('SignUp')),

                      SizedBox(height: screenHeight * 0.01),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          final isLoading = authState.currentState == AuthStates.Loading;
                          return AppButton(
                            'Login',
                            color: themeState.theme[appColors.textSecondaryColor]!,
                            bgcolor: themeState.theme[appColors.accentColor]!,
                            isLoading: isLoading,
                            type: ButtonType.primary,
                            onPressed: isLoading
                                ? null
                                : () {
                              if (!_formKey.currentState!.validate()) return;
                              context.read<AuthBloc>().add(AuthLogin());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );

  }
}
