import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_shopping_store/Model/order/order.dart';

part 'seller_orders_screen_events.dart';
part 'seller_orders_screen_state.dart';

class SellerOrdersBloc extends Bloc<SellerOrdersScreenEvent, SellerOrdersScreenState> {
  SellerOrdersBloc() : super(const SellerOrdersScreenState()) {
    on<LoadSellerOrders>(_onLoadSellerOrders);
    on<AddSellerOrder>(_onAddSellerOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelSellerOrder>(_onCancelSellerOrder);
    on<DeleteSellerOrder>(_onDeleteSellerOrder);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
    on<SearchSellerOrders>(_onSearchSellerOrders);
    on<RefreshSellerOrders>(_onRefreshSellerOrders);
  }

  // Load Orders
  Future<void> _onLoadSellerOrders(
      LoadSellerOrders event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      // TODO: Replace with actual API call
      // final orders = await orderRepository.getSellerOrders(event.sellerId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      final List<OrderModel> orders = [];

      if (orders.isEmpty) {
        emit(state.copyWith(
          status: OrdersStatus.empty,
          orders: [],
          filteredOrders: [],
        ));
      } else {
        final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.totalAmount);

        emit(state.copyWith(
          status: OrdersStatus.loaded,
          orders: orders,
          filteredOrders: [],
          totalOrders: orders.length,
          totalRevenue: totalRevenue,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to load orders: ${error.toString()}',
      ));
    }
  }

  // Add Order
  Future<void> _onAddSellerOrder(
      AddSellerOrder event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    emit(state.copyWith(status: OrdersStatus.updating));

    try {
      // TODO: Replace with actual API call
      // await orderRepository.addOrder(event.order);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = List<OrderModel>.from(state.orders)..add(event.order);
      final totalRevenue = updatedOrders.fold(0.0, (sum, order) => sum + order.totalAmount);

      emit(state.copyWith(
        status: OrdersStatus.updated,
        orders: updatedOrders,
        totalOrders: updatedOrders.length,
        totalRevenue: totalRevenue,
      ));

      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: OrdersStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to add order: ${error.toString()}',
      ));
    }
  }

  // Update Order Status
  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatus event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    emit(state.copyWith(status: OrdersStatus.updating));

    try {
      // TODO: Replace with actual API call
      // await orderRepository.updateOrderStatus(event.orderId, event.status);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders.map((order) {
        if (order.uid == event.orderId) {
          // Update order status and set appropriate dates
          DateTime? shippingDate = order.shippingDate;
          DateTime? deliveryDate = order.deliveryDate;
          DateTime? cancelledDate = order.cancelledDate;

          if (event.status == 'shipped' && order.shippingDate == null) {
            shippingDate = DateTime.now();
          } else if (event.status == 'delivered' && order.deliveryDate == null) {
            deliveryDate = DateTime.now();
          } else if (event.status == 'cancelled' && order.cancelledDate == null) {
            cancelledDate = DateTime.now();
          }

          return order.copyWith(
            status: event.status,
            shippingDate: shippingDate,
            deliveryDate: deliveryDate,
            cancelledDate: cancelledDate,
          );
        }
        return order;
      }).toList();

      emit(state.copyWith(
        status: OrdersStatus.updated,
        orders: updatedOrders,
      ));

      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: OrdersStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to update order status: ${error.toString()}',
      ));
    }
  }

  // Cancel Order
  Future<void> _onCancelSellerOrder(
      CancelSellerOrder event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    emit(state.copyWith(status: OrdersStatus.updating));

    try {
      // TODO: Replace with actual API call
      // await orderRepository.cancelOrder(event.orderId, cancellationReason);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders.map((order) {
        if (order.uid == event.orderId) {
          return order.copyWith(
            status: 'cancelled',
            cancelledDate: DateTime.now(),
            cancellationReason: event.cancellationReason,
          );
        }
        return order;
      }).toList();

      emit(state.copyWith(
        status: OrdersStatus.updated,
        orders: updatedOrders,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: OrdersStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to cancel order: ${error.toString()}',
      ));
    }
  }

  // Delete Order
  Future<void> _onDeleteSellerOrder(
      DeleteSellerOrder event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    emit(state.copyWith(status: OrdersStatus.deleting));

    try {
      // TODO: Replace with actual API call
      // await orderRepository.deleteOrder(event.orderId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders
          .where((order) => order.uid != event.orderId)
          .toList();

      final totalRevenue = updatedOrders.fold(0.0, (sum, order) => sum + order.totalAmount);

      emit(state.copyWith(
        status: OrdersStatus.deleted,
        orders: updatedOrders,
        totalOrders: updatedOrders.length,
        totalRevenue: totalRevenue,
      ));

      // Check if empty
      if (updatedOrders.isEmpty) {
        emit(state.copyWith(status: OrdersStatus.empty));
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(status: OrdersStatus.loaded));
      }
    } catch (error) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to delete order: ${error.toString()}',
      ));
    }
  }

  // Filter Orders by Status
  void _onFilterOrdersByStatus(
      FilterOrdersByStatus event,
      Emitter<SellerOrdersScreenState> emit,
      ) {
    emit(state.copyWith(
      status: OrdersStatus.filtering,
      currentFilter: event.status,
    ));

    if (event.status == null || event.status!.isEmpty) {
      // Show all orders
      emit(state.copyWith(
        filteredOrders: [],
        status: OrdersStatus.loaded,
      ));
    } else {
      // Filter orders by status
      final filtered = state.orders
          .where((order) => order.status == event.status)
          .toList();

      emit(state.copyWith(
        filteredOrders: filtered,
        status: filtered.isEmpty ? OrdersStatus.empty : OrdersStatus.loaded,
      ));
    }
  }

  // Search Orders
  void _onSearchSellerOrders(
      SearchSellerOrders event,
      Emitter<SellerOrdersScreenState> emit,
      ) {
    emit(state.copyWith(
      status: OrdersStatus.searching,
      searchQuery: event.query,
    ));

    if (event.query.isEmpty) {
      // Clear search
      emit(state.copyWith(
        filteredOrders: [],
        status: OrdersStatus.loaded,
      ));
    } else {
      // Search in orders by order number, buyer name, or items
      final searchResults = state.orders.where((order) {
        return order.orderNumber.toLowerCase().contains(event.query.toLowerCase()) ||
            order.buyerName.toLowerCase().contains(event.query.toLowerCase()) ||
            order.buyerEmail.toLowerCase().contains(event.query.toLowerCase()) ||
            order.items.any((item) =>
                item.name.toLowerCase().contains(event.query.toLowerCase())
            );
      }).toList();

      emit(state.copyWith(
        filteredOrders: searchResults,
        status: searchResults.isEmpty ? OrdersStatus.empty : OrdersStatus.loaded,
      ));
    }
  }

  // Refresh Orders
  Future<void> _onRefreshSellerOrders(
      RefreshSellerOrders event,
      Emitter<SellerOrdersScreenState> emit,
      ) async {
    // Trigger load orders again
    add(LoadSellerOrders(sellerId: event.sellerId));
  }
}