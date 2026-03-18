import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';


class MainNavBloc extends Bloc<MainNavEvent, MainNavState> {
  MainNavBloc() : super(const MainNavState()) {
    on<MainNavTabChanged>(_onTabChanged);
    on<MainNavBadgeUpdated>(_onBadgeUpdated);
  }

  void _onTabChanged(MainNavTabChanged event, Emitter<MainNavState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onBadgeUpdated(MainNavBadgeUpdated event, Emitter<MainNavState> emit) {
    emit(state.copyWith(
      cartItemCount: event.cartItemCount,
      pendingOrderCount: event.pendingOrderCount,
    ));
  }
}