
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'seller_main_screen_events.dart';
part 'seller_main_screen_state.dart';

class SellerMainNavBloc extends Bloc<SellerMainNavEvents, SellerMainNavState>{
  SellerMainNavBloc() : super(const SellerMainNavState()){
    on<SellerMainNavTabChanged>(_onTabChanged);

  }
  void _onTabChanged(SellerMainNavTabChanged event, Emitter<SellerMainNavState> emit){
    emit(state.copyWith(selectedIndex: event.index));

  }
}