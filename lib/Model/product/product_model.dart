import 'package:equatable/equatable.dart';

class ProductModel extends Equatable{
  final String uid;
  final String sellerId;
  final String name;
  final String description;
  final String category;
  final double salePrice;
  final double costPrice;
  final int quantity;

  const ProductModel({
    this.uid = '',
    this.sellerId = '',
    this.name = '',
    this.description = '',
    this.category = '',
    this.salePrice = 12,
    this.costPrice = 9,
    this.quantity = 20,
  });

  @override
  List<Object?> get props => [uid, sellerId, name, description, category, salePrice, costPrice, quantity];


}