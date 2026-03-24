import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String productId;
  final String sellerId;
  final String name;
  final String category;
  final String description;
  final double salePrice;
  final double costPrice;
  final int quantity;
  final String imageUrl;

  const ProductModel({
    this.productId = '',
    this.sellerId = '',
    this.name = '',
    this.description = '',
    this.category = '',
    this.salePrice = 0,
    this.costPrice = 0,
    this.quantity = 0,
    this.imageUrl = '',
  });

  ProductModel copyWith({
    String? uid,
    String? sellerId,
    String? name,
    String? description,
    String? category,
    double? salePrice,
    double? costPrice,
    int? quantity,
    String? imageUrl,
  }) {
    return ProductModel(
      productId: uid ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      salePrice: salePrice ?? this.salePrice,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  @override
  List<Object?> get props => [
    productId,
    sellerId,
    name,
    description,
    category,
    salePrice,
    costPrice,
    quantity,
    imageUrl,
  ];
}