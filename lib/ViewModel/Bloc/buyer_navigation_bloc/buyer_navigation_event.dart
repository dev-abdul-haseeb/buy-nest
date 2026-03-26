part of 'buyer_navigation_bloc.dart';

abstract class BuyerNavigationEvent extends Equatable{
  BuyerNavigationEvent();

  @override

  List<Object?> get props => [];
}

class ChangeIndex extends BuyerNavigationEvent {
  int index;

  ChangeIndex({
    required this.index,
  });

  @override

  List<Object?> get props => [index];
}