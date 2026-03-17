part of 'auth_bloc.dart';

class AuthState extends Equatable {
  AuthStates currentState;
  PersonModel userModel;
  String message;

  AuthState ({
    this.currentState = AuthStates.Initial,
    this.userModel = const PersonModel(),
    this.message = '',
  });

  AuthState copyWith({AuthStates? newState, PersonModel? newModel, String? newMessage}) {
    return AuthState(
      currentState: newState ?? this.currentState,
      userModel: newModel ?? this.userModel,
      message: newMessage?? this.message,
    );
  }

  @override
  List<Object?> get props => [currentState, userModel, message];

}
