import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String uid;
  final String sellerId;
  final String name;
  final String description;
  final String category;
  final double salePrice;
  final double costPrice;
  final int quantity;
  final String? imageUrl; // Add this line

  const ProductModel({
    this.uid = '',
    this.sellerId = '',
    this.name = '',
    this.description = '',
    this.category = '',
    this.salePrice = 12,
    this.costPrice = 9,
    this.quantity = 20,
    this.imageUrl, // Add this line
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
      uid: uid ?? this.uid,
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
    uid,
    sellerId,
    name,
    description,
    category,
    salePrice,
    costPrice,
    quantity,
    imageUrl, // Add this line
  ];
}