import 'package:equatable/equatable.dart';

import '../../config/enums/enums.dart';

class SaleProductModel extends Equatable{

  String saleProductId;
  String orderId;
  String productId;
  int quantity;
  ProductStatus status;

  SaleProductModel({
    this.saleProductId = '',
    this.orderId = '',
    this.productId = '',
    this.quantity = 0,
    this.status = ProductStatus.packing
  });

  SaleProductModel copyWith ({
    String? newSaleProductId,
    String? newOrderId,
    String? newProductId,
    int? newQuantity,
    ProductStatus? newStatus,
  }) {
    return SaleProductModel(
      saleProductId: newSaleProductId ?? saleProductId,
      orderId: newOrderId ?? orderId,
      productId: newProductId ?? productId,
      quantity: newQuantity ?? quantity,
      status: newStatus ?? status
    );
  }

  @override
  List<Object?> get props => [saleProductId, orderId, productId, quantity, status];

}