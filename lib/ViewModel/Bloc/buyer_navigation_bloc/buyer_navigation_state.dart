part of 'buyer_navigation_bloc.dart';

class BuyerNavigationState extends Equatable {

  int selectedIndex;

  BuyerNavigationState( {
    this.selectedIndex = 0,
  });

  BuyerNavigationState copyWith({int? newIndex}) {
    return BuyerNavigationState(
      selectedIndex: newIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [selectedIndex];

}