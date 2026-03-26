import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'buyer_navigation_event.dart';
part 'buyer_navigation_state.dart';

class BuyerNavigationBloc extends Bloc<BuyerNavigationEvent, BuyerNavigationState> {

  BuyerNavigationBloc(): super(BuyerNavigationState()) {
    on<ChangeIndex>(_changeIndex);
  }

  void _changeIndex (ChangeIndex event, Emitter<BuyerNavigationState> emit) {
    emit(state.copyWith(newIndex: event.index));
  }

}