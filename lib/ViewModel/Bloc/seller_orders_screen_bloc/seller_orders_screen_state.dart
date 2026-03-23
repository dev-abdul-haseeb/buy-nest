part of 'seller_orders_screen_bloc.dart';

enum OrdersStatus {
  initial,
  loading,
  loaded,
  error,
  empty,
  updating,
  updated,
  deleting,
  deleted,
  filtering,
  searching
}

class SellerOrdersScreenState extends Equatable {
  final OrdersStatus status;
  final List<OrderModel> orders;
  final List<OrderModel> filteredOrders;
  final String? errorMessage;
  final String? currentFilter;
  final String? searchQuery;
  final int totalOrders;
  final double totalRevenue;

  const SellerOrdersScreenState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.filteredOrders = const [],
    this.errorMessage,
    this.currentFilter,
    this.searchQuery,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
  });

  // Helper getters
  bool get isLoading => status == OrdersStatus.loading;
  bool get isUpdating => status == OrdersStatus.updating;
  bool get isDeleting => status == OrdersStatus.deleting;
  bool get hasError => status == OrdersStatus.error;
  bool get isEmpty => status == OrdersStatus.empty;
  bool get isLoaded => status == OrdersStatus.loaded;

  // Get displayed orders (filtered or all)
  List<OrderModel> get displayOrders =>
      filteredOrders.isNotEmpty ? filteredOrders : orders;

  // Get pending orders count
  int get pendingOrdersCount =>
      orders.where((order) => order.isPending || order.isProcessing).length;

  // Get completed orders count
  int get completedOrdersCount =>
      orders.where((order) => order.isDelivered).length;

  // Get cancelled orders count
  int get cancelledOrdersCount =>
      orders.where((order) => order.isCancelled).length;

  // Get order count by status
  int getOrderCountByStatus(String status) {
    return orders.where((order) => order.status == status).length;
  }

  // Get orders by status
  List<OrderModel> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }

  // Calculate statistics
  Map<String, dynamic> getStatistics() {
    final totalValue = orders.fold(0.0, (sum, order) => sum + order.totalAmount);
    final completedOrders = orders.where((order) => order.isDelivered).length;
    final pendingOrders = orders.where((order) => order.isPending || order.isProcessing).length;
    final cancelledOrders = orders.where((order) => order.isCancelled).length;

    return {
      'total': orders.length,
      'totalValue': totalValue,
      'completed': completedOrders,
      'pending': pendingOrders,
      'cancelled': cancelledOrders,
      'averageOrderValue': orders.isEmpty ? 0 : totalValue / orders.length,
    };
  }

  SellerOrdersScreenState copyWith({
    OrdersStatus? status,
    List<OrderModel>? orders,
    List<OrderModel>? filteredOrders,
    String? errorMessage,
    String? currentFilter,
    String? searchQuery,
    int? totalOrders,
    double? totalRevenue,
  }) {
    return SellerOrdersScreenState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      errorMessage: errorMessage ?? this.errorMessage,
      currentFilter: currentFilter ?? this.currentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    filteredOrders,
    errorMessage,
    currentFilter,
    searchQuery,
    totalOrders,
    totalRevenue,
  ];
}