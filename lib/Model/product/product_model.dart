import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends Equatable {
  final String productId;
  final String sellerId;
  final String name;
  final String category;
  final String description;
  final double salePrice;
  final double costPrice;
  final int quantity;
  final List<String> imageUrls;

  const ProductModel({
    this.productId = '',
    this.sellerId = '',
    this.name = '',
    this.description = '',
    this.category = '',
    this.salePrice = 0.0,
    this.costPrice = 0.0,
    this.quantity = 0,
    this.imageUrls = const [],
  });

  // Factory method to create ProductModel from JSON (Firestore document)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      salePrice: (json['salePrice'] ?? 0.0).toDouble(),
      costPrice: (json['costPrice'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
    );
  }

  // Factory method to create ProductModel from Firestore document snapshot
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: doc.id,
      sellerId: data['sellerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      salePrice: (data['salePrice'] ?? 0.0).toDouble(),
      costPrice: (data['costPrice'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'])
          : [],
    );
  }

  // Convert ProductModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'category': category,
      'salePrice': salePrice,
      'costPrice': costPrice,
      'quantity': quantity,
      'imageUrls': imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert ProductModel to JSON without timestamps (for updates)
  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'category': category,
      'salePrice': salePrice,
      'costPrice': costPrice,
      'quantity': quantity,
      'imageUrls': imageUrls,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Remove null values
    data.removeWhere((key, value) => value == null);
    return data;
  }

  // Fixed copyWith method with proper parameter names and types
  ProductModel copyWith({
    String? productId,
    String? sellerId,
    String? name,
    String? description,
    String? category,
    double? salePrice,
    double? costPrice,
    int? quantity,
    List<String>? imageUrls,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      salePrice: salePrice ?? this.salePrice,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  // Helper method to add a single image URL
  ProductModel addImageUrl(String imageUrl) {
    final updatedUrls = List<String>.from(imageUrls)..add(imageUrl);
    return copyWith(imageUrls: updatedUrls);
  }

  // Helper method to add multiple image URLs
  ProductModel addImageUrls(List<String> newImageUrls) {
    final updatedUrls = List<String>.from(imageUrls)..addAll(newImageUrls);
    return copyWith(imageUrls: updatedUrls);
  }

  // Helper method to remove an image URL
  ProductModel removeImageUrl(String imageUrl) {
    final updatedUrls = List<String>.from(imageUrls)..remove(imageUrl);
    return copyWith(imageUrls: updatedUrls);
  }

  // Helper method to remove image at index
  ProductModel removeImageAtIndex(int index) {
    if (index >= 0 && index < imageUrls.length) {
      final updatedUrls = List<String>.from(imageUrls)..removeAt(index);
      return copyWith(imageUrls: updatedUrls);
    }
    return this;
  }

  // Helper method to update quantity
  ProductModel updateQuantity(int newQuantity) {
    return copyWith(quantity: newQuantity);
  }

  // Helper method to update price
  ProductModel updatePrice(double newSalePrice, {double? newCostPrice}) {
    return copyWith(
      salePrice: newSalePrice,
      costPrice: newCostPrice ?? costPrice,
    );
  }

  // Helper method to check if product is in stock
  bool get isInStock => quantity > 0;

  // Helper method to check if product is low stock (less than 10)
  bool get isLowStock => quantity > 0 && quantity < 10;

  // Helper method to get profit margin
  double get profitMargin => salePrice - costPrice;

  // Helper method to get profit percentage
  double get profitPercentage => costPrice > 0 ? ((salePrice - costPrice) / costPrice) * 100 : 0;

  // Helper method to get total inventory value
  double get totalInventoryValue => costPrice * quantity;

  // Helper method to get total sale value
  double get totalSaleValue => salePrice * quantity;

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
    imageUrls,
  ];
}