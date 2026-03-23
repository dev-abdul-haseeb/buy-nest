
part of 'seller_main_screen_bloc.dart';

class SellerMainNavState extends Equatable{
  final int selectedIndex;
  const SellerMainNavState({this.selectedIndex=0});

  SellerMainNavState copyWith({int? selectedIndex}){
    return SellerMainNavState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[selectedIndex];


}