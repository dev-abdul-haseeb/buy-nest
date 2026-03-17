part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object?> get props => [];

}

class AuthCheckRequested extends AuthEvent {}

class AuthLogOut extends AuthEvent {}

class AuthLogin extends AuthEvent {}

class AuthSignUp extends AuthEvent {}

class NameChanged extends AuthEvent {
  String name;
  NameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class CnicChanged extends AuthEvent{
  String cnic;
  CnicChanged({required this.cnic});

  @override
  List<Object?> get props => [cnic];

}

class PhoneChanged extends AuthEvent{
  String phone;
  PhoneChanged({required this.phone});

  @override
  List<Object?> get props => [phone];

}

class RoleChanged extends AuthEvent {
  PersonRole role;
  RoleChanged({required this.role});

  @override
  List<Object?> get props => [role];

}

class EmailChanged extends AuthEvent {
  String email;
  EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  String password;
  PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class ClearAuthFields extends AuthEvent {}

class ResetPassword extends AuthEvent {}