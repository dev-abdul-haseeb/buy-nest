part of 'main_screen_bloc.dart';

class MainNavState extends Equatable {
  final int selectedIndex;
  final int cartItemCount;
  final int pendingOrderCount;

  const MainNavState({
    this.selectedIndex = 0,
    this.cartItemCount = 0,
    this.pendingOrderCount = 0,
  });

  MainNavState copyWith({
    int? selectedIndex,
    int? cartItemCount,
    int? pendingOrderCount,
  }) {
    return MainNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      pendingOrderCount: pendingOrderCount ?? this.pendingOrderCount,
    );
  }

  @override
  List<Object> get props => [selectedIndex, cartItemCount, pendingOrderCount];
}