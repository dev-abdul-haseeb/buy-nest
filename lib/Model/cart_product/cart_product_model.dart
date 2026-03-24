import 'package:equatable/equatable.dart';

import '../../config/enums/enums.dart';

class CartProductModel extends Equatable{

  String cartProductId;
  String buyerId;
  String productId;
  int quantity;

  CartProductModel({
    this.cartProductId = '',
    this.buyerId = '',
    this.productId = '',
    this.quantity = 0,

  });

  CartProductModel copyWith ({
    String? newCartProductId,
    String? newBuyerId,
    String? newProductId,
    int? newQuantity,
  }) {
    return CartProductModel(
      cartProductId: newCartProductId ?? cartProductId,
      buyerId: newBuyerId ?? buyerId,
      productId: newProductId ?? productId,
      quantity: newQuantity ?? quantity,
    );
  }

  @override
  List<Object?> get props => [cartProductId, buyerId, productId, quantity];

}