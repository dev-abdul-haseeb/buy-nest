part of 'obscure_text_bloc.dart';

class ObscureTextState extends Equatable {

  final bool obscureText;

  const ObscureTextState ({
    this.obscureText = true,
  });

  ObscureTextState copyWith({bool? newBool}) {
    return ObscureTextState(
      obscureText: newBool ?? obscureText,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [obscureText];

}