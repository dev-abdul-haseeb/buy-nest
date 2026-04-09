import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buyer_home_screen_state.dart';
part 'buyer_home_screen_event.dart';

class BuyerHomeScreenBloc extends Bloc<BuyerHomeScreenEvent, BuyerHomeScreenState> {
  BuyerHomeScreenBloc() : super(BuyerHomeScreenState()) {

  }
}