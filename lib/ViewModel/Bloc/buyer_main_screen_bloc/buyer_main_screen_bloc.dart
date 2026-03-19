import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buyer_main_screen_event.dart';
part 'buyer_main_screen_state.dart';


class BuyerMainNavBloc extends Bloc<BuyerMainNavEvent, BuyerMainNavState> {
  BuyerMainNavBloc() : super(const BuyerMainNavState()) {
    on<BuyerMainNavTabChanged>(_onTabChanged);
    on<BuyerMainNavBadgeUpdated>(_onBadgeUpdated);
  }

  void _onTabChanged(BuyerMainNavTabChanged event, Emitter<BuyerMainNavState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onBadgeUpdated(BuyerMainNavBadgeUpdated event, Emitter<BuyerMainNavState> emit) {
    emit(state.copyWith(
      cartItemCount: event.cartItemCount,
      pendingOrderCount: event.pendingOrderCount,
    ));
  }
}