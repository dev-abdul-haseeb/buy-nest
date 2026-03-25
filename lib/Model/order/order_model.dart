import 'package:equatable/equatable.dart';

import '../../config/enums/enums.dart';

class OrderModel extends Equatable{

  final String orderId;
  final String buyerId;
  final DateTime date;
  final OrderStatus status;

  OrderModel({
    this.orderId = '',
    this.buyerId = '',
    DateTime? date,
    this.status = OrderStatus.incomplete,
  }) : date = date ?? DateTime.now();

  OrderModel copyWith ({
    String? newOrderId,
    String? newBuyerId,
    DateTime? newDate,
    OrderStatus? newStatus
  }) {
    return OrderModel(
      orderId: newOrderId ?? orderId,
      buyerId: newBuyerId ?? buyerId,
      date: newDate ?? date,
      status: newStatus ?? status,
    );
  }

  @override
  List<Object?> get props => [orderId, buyerId, date, status];

}