part of 'seller_orders_screen_bloc.dart';


class SellerOrdersScreenState extends Equatable {
  final List<OrderModel> orders;
  final String? errorMessage;
  final int totalOrders;

  const SellerOrdersScreenState({
    this.orders = const [],
    this.errorMessage,
    this.totalOrders = 0,
  });

  // Get order count by status
  int getOrderCountByStatus(String status) {
    return orders.where((order) => order.status == status).length;
  }

  // Get orders by status
  List<OrderModel> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == getOrderCountByStatus(status)).toList();
  }
  int getOrderStatus(String status){
    switch (status) {
      case 'pending':
        return 0;
      case 'shipped':
        return 1;
        case 'delivered':
        return 2;
      case 'cancelled':
        return 3;
      default:
        return 0;
    }
  }

  // Calculate statistics


  SellerOrdersScreenState copyWith({
    List<OrderModel>? orders,
    String? errorMessage,
    int? totalOrders,
  }) {
    return SellerOrdersScreenState(
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    errorMessage,
    totalOrders,
  ];
}