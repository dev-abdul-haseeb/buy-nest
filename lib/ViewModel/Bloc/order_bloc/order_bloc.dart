import 'package:bloc/bloc.dart';
import 'package:ecommerce_shopping_store/repository/orders_repository/orders_repository.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  
  OrdersRepository _ordersRepository = OrdersRepository();

  OrderBloc(): super(OrderState()) {
    on<GetNumberOfOrders>(_getNumberOfOrders);
  }

  void _getNumberOfOrders(GetNumberOfOrders event, Emitter<OrderState> emit) async {
    int count = await _ordersRepository.getOrderCountByBuyer(event.buyerId);
    emit(state.copyWith(newNumberOfOrders: count));
  }

}