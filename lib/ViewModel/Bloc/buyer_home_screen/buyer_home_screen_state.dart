part of 'buyer_home_screen_bloc.dart';

class BuyerHomeScreenState extends Equatable{
  int value;
  BuyerHomeScreenState ({
    this.value = 0,
  });
  @override
  List<Object?> get props => [value];
}