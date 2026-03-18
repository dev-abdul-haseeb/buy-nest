part of 'main_screen_bloc.dart';

abstract class MainNavEvent extends Equatable {
  const MainNavEvent();

  @override
  List<Object> get props => [];
}

class MainNavTabChanged extends MainNavEvent {
  final int index;
  const MainNavTabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class MainNavBadgeUpdated extends MainNavEvent {
  final int cartItemCount;
  final int pendingOrderCount;
  const MainNavBadgeUpdated({
    this.cartItemCount = 0,
    this.pendingOrderCount = 0,
  });

  @override
  List<Object> get props => [cartItemCount, pendingOrderCount];
}