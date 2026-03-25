import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_shopping_store/config/enums/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_shopping_store/Model/order/order_model.dart';

part 'seller_orders_screen_events.dart';
part 'seller_orders_screen_state.dart';

class SellerOrdersBloc extends Bloc<SellerOrdersScreenEvent, SellerOrdersScreenState> {
  SellerOrdersBloc() : super(const SellerOrdersScreenState()) {
    on<LoadSellerOrders>(_onLoadSellerOrders);
    on<AddSellerOrder>(_onAddSellerOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelSellerOrder>(_onCancelSellerOrder);
    on<DeleteSellerOrder>(_onDeleteSellerOrder);

  }

  // Load Orders
  Future<void> _onLoadSellerOrders(LoadSellerOrders event, Emitter<SellerOrdersScreenState> emit,) async {

    try {
      // TODO: Replace with actual API call
      // final orders = await orderRepository.getSellerOrders(event.sellerId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      final List<OrderModel> orders = [];

      if (orders.isEmpty) {
        emit(state.copyWith(
          orders: [],
        ));
      } else {

        emit(state.copyWith(
          orders: orders,
          totalOrders: orders.length,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to load orders: ${error.toString()}',
      ));
    }
  }

  // Add Order
  Future<void> _onAddSellerOrder(AddSellerOrder event, Emitter<SellerOrdersScreenState> emit,) async {

    try {
      // TODO: Replace with actual API call
      // await orderRepository.addOrder(event.order);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = List<OrderModel>.from(state.orders)..add(event.order);

      emit(state.copyWith(
        orders: updatedOrders,
        totalOrders: updatedOrders.length,
      ));
      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to add order: ${error.toString()}',
      ));
    }
  }

  // Update Order Status
  Future<void> _onUpdateOrderStatus(UpdateOrderStatus event, Emitter<SellerOrdersScreenState> emit,) async {

    try {
      // TODO: Replace with actual API call
      // await orderRepository.updateOrderStatus(event.orderId, event.status);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders.map((order) {
        if (order.orderId == event.orderId) {



          return order.copyWith(
            newBuyerId: order.buyerId,
            newDate: order.date,
            newOrderId: order.orderId,
            newStatus: order.status,
          );
        }
        return order;
      }).toList();

      emit(state.copyWith(
        orders: updatedOrders,
      ));

      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to update order status: ${error.toString()}',
      ));
    }
  }

  // Cancel Order
  Future<void> _onCancelSellerOrder(CancelSellerOrder event, Emitter<SellerOrdersScreenState> emit,) async {

    try {
      // TODO: Replace with actual API call
      // await orderRepository.cancelOrder(event.orderId, cancellationReason);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders.map((order) {
        if (order.orderId == event.orderId) {
          return order.copyWith(
            newStatus: OrderStatus.cancelled,
          );
        }
        return order;
      }).toList();

      emit(state.copyWith(

        orders: updatedOrders,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to cancel order: ${error.toString()}',
      ));
    }
  }

  // Delete Order
  Future<void> _onDeleteSellerOrder(DeleteSellerOrder event, Emitter<SellerOrdersScreenState> emit,) async {

    try {
      // TODO: Replace with actual API call
      // await orderRepository.deleteOrder(event.orderId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders
          .where((order) => order.orderId != event.orderId)
          .toList();


      emit(state.copyWith(
        orders: updatedOrders,
        totalOrders: updatedOrders.length,
      ));

      // Check if empty
      if (updatedOrders.isEmpty) {
        emit(state.copyWith(orders: []));
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to delete order: ${error.toString()}',
      ));
    }
  }

  // Filter Orders by Status
  // void _onFilterOrdersByStatus(FilterOrdersByStatus event, Emitter<SellerOrdersScreenState> emit,) {
  //
  //
  //   if (event.status == null || event.status!.isEmpty) {
  //     // Show all orders
  //     emit(state.copyWith(
  //       filteredOrders: [],
  //       status: OrdersStatus.loaded,
  //     ));
  //   } else {
  //     // Filter orders by status
  //     final filtered = state.orders
  //         .where((order) => order.status == event.status)
  //         .toList();
  //
  //     emit(state.copyWith(
  //       filteredOrders: filtered,
  //       status: filtered.isEmpty ? OrdersStatus.empty : OrdersStatus.loaded,
  //     ));
  //   }
  // }

}