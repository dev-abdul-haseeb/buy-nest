part of 'order_bloc.dart';

class OrderState extends Equatable {

  int number_of_orders;

  OrderState ({
    this.number_of_orders = 0,
  });

  OrderState copyWith ({int? newNumberOfOrders}) {
    return OrderState(
      number_of_orders: newNumberOfOrders ?? this.number_of_orders,
    );
  }

  @override
  List<Object?> get props => [number_of_orders];

}