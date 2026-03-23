part of 'seller_main_screen_bloc.dart';


abstract class SellerMainNavEvents extends Equatable{
  const SellerMainNavEvents();

  @override
  List<Object> get props => [];
}

class SellerMainNavTabChanged extends SellerMainNavEvents{
  final int index;
  const SellerMainNavTabChanged(this.index);

  @override
  List<Object> get props => [index];
}