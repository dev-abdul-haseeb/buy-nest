part of 'seller_orders_screen_bloc.dart';

abstract class SellerOrdersScreenEvent extends Equatable {
  const SellerOrdersScreenEvent();

  @override
  List<Object?> get props => [];
}

// Load Orders Event
class LoadSellerOrders extends SellerOrdersScreenEvent {
  final String sellerId;

  const LoadSellerOrders({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

// Add Order Event
class AddSellerOrder extends SellerOrdersScreenEvent {
  final OrderModel order;

  const AddSellerOrder({required this.order});

  @override
  List<Object?> get props => [order];
}

// Update Order Status Event
class UpdateOrderStatus extends SellerOrdersScreenEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}

// Cancel Order Event
class CancelSellerOrder extends SellerOrdersScreenEvent {
  final String orderId;
  final String? cancellationReason;

  const CancelSellerOrder({
    required this.orderId,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [orderId, cancellationReason];
}

// Delete Order Event
class DeleteSellerOrder extends SellerOrdersScreenEvent {
  final String orderId;

  const DeleteSellerOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// Filter Orders by Status
class FilterOrdersByStatus extends SellerOrdersScreenEvent {
  final String? status;

  const FilterOrdersByStatus({this.status});

  @override
  List<Object?> get props => [status];
}

// Search Orders
class SearchSellerOrders extends SellerOrdersScreenEvent {
  final String query;

  const SearchSellerOrders({required this.query});

  @override
  List<Object?> get props => [query];
}

// Refresh Orders
class RefreshSellerOrders extends SellerOrdersScreenEvent {
  final String sellerId;

  const RefreshSellerOrders({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}