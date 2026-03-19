part of 'buyer_main_screen_bloc.dart';

class BuyerMainNavState extends Equatable {
  final int selectedIndex;
  final int cartItemCount;
  final int pendingOrderCount;

  const BuyerMainNavState({
    this.selectedIndex = 0,
    this.cartItemCount = 0,
    this.pendingOrderCount = 0,
  });

  BuyerMainNavState copyWith({
    int? selectedIndex,
    int? cartItemCount,
    int? pendingOrderCount,
  }) {
    return BuyerMainNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      pendingOrderCount: pendingOrderCount ?? this.pendingOrderCount,
    );
  }

  @override
  List<Object> get props => [selectedIndex, cartItemCount, pendingOrderCount];
}