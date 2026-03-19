part of 'buyer_main_screen_bloc.dart';

abstract class BuyerMainNavEvent extends Equatable {
  const BuyerMainNavEvent();

  @override
  List<Object> get props => [];
}

class BuyerMainNavTabChanged extends BuyerMainNavEvent {
  final int index;
  const BuyerMainNavTabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class BuyerMainNavBadgeUpdated extends BuyerMainNavEvent {
  final int cartItemCount;
  final int pendingOrderCount;
  const BuyerMainNavBadgeUpdated({
    this.cartItemCount = 0,
    this.pendingOrderCount = 0,
  });

  @override
  List<Object> get props => [cartItemCount, pendingOrderCount];
}