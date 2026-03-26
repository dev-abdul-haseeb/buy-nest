part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  OrderEvent();
  @override
  List<Object?> get props => [];
}

class GetNumberOfOrders extends OrderEvent {
  String buyerId;

  GetNumberOfOrders ({
    required this.buyerId
  });

  List<Object?> get props => [buyerId];

}