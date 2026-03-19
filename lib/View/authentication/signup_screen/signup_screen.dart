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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late ObscureTextBloc _obscureTextBloc;

  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> nodes = [
    FocusNode(), // Name: 0
    FocusNode(), // Phone: 1
    FocusNode(), // Cnic: 2
    FocusNode(), // Email: 3
    FocusNode(), // Password: 4
  ];

  final List<TextInputType> inputTypes = [
    TextInputType.text,
    TextInputType.phone,
    TextInputType.phone,
    TextInputType.emailAddress,
    TextInputType.text,
  ];

  final List<TextCapitalization> capitalizations = [
    TextCapitalization.words,
    TextCapitalization.none,
    TextCapitalization.none,
    TextCapitalization.none,
    TextCapitalization.none,
  ];

  final List<String> labels = [
    'Name',
    'Phone',
    'Cnic',
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

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required.';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Phone must contain digits only.';
    }
    if (value.trim().length < 10 || value.trim().length > 13) {
      return 'Phone must be between 10 and 13 digits.';
    }
    return null;
  }

  String? _validateCnic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNIC is required.';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'CNIC must contain digits only.';
    }
    if (value.trim().length != 13) {
      return 'CNIC must be exactly 13 digits.';
    }
    return null;
  }

  String? _validatorForIndex(int index, String? value) {
    switch (index) {
      case 1: return _validatePhone(value);
      case 2: return _validateCnic(value);
      case 3: return _validateEmail(value);
      case 4: return _validatePassword(value); // Password
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
      case 0: return NameChanged(name: value);
      case 1: return PhoneChanged(phone: value);
      case 2: return CnicChanged(cnic: value);
      case 3: return EmailChanged(email: value);
      case 4: return PasswordChanged(password: value);
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
                  (state.message?.isNotEmpty ?? false) ? state.message! : (isSuccess ? 'Sign up successful!' : 'Sign up failed.');
                  showFlashbar(context, message, isSuccess);
                  if(isSuccess || state.message == 'Account created. Waiting for approval...') {
                    Navigator.pop(context);
                  }
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
              
                      SizedBox(height: screenHeight * 0.02),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return DropdownButtonFormField<PersonRole>(
                            value: authState.userModel.role,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'Role',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              prefixIcon: AppIcons.appIcon['Role'],
                              prefixIconColor: themeState.theme[appColors.primaryColor],
                            ),
                            items: PersonRole.values
                                .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role.name[0].toUpperCase() + role.name.substring(1),
                              ),
                            ))
                                .toList(),
                            validator: (value) =>
                            value == null ? 'Please select a role.' : null,
                            onChanged: (PersonRole? role) {
                              if (role == null) return;
                              context.read<AuthBloc>().add(RoleChanged(role: role));
                            },
                          );
                        },
                      ),
              

                      SizedBox(height: screenHeight * 0.01),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          final isLoading = authState.currentState == AuthStates.Loading;
                          return AppButton(
                            'Sign Up',
                            color: themeState.theme[appColors.textSecondaryColor]!,
                            bgcolor: themeState.theme[appColors.accentColor]!,
                            isLoading: isLoading,
                            type: ButtonType.primary,
                            onPressed: isLoading
                                ? null
                                : () {
                              if (!_formKey.currentState!.validate()) return;
                              context.read<AuthBloc>().add(AuthSignUp());
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
