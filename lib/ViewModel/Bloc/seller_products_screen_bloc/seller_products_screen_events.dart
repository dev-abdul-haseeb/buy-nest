part of 'seller_products_screen_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

// Load Products Event
class LoadProducts extends ProductsEvent {
  //final String sellerId;

  const LoadProducts();

  @override
  List<Object?> get props => [];
}

// Add Product Event
class AddProduct extends ProductsEvent {
  final ProductModel product;
  final List<File>? imageFiles;
  final List<String>? imageUrls;

  const AddProduct({
    required this.product,
    required this.imageFiles,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [product, imageFiles, imageUrls];
}

// Update Product Event
class UpdateProduct extends ProductsEvent {
  final ProductModel product;
  final List<File>? newImageFiles;
  final List<String>? newImageUrls;
  final List<String>? imagesToRemove;


  const UpdateProduct({
    required this.product,
    this.newImageFiles,
    this.newImageUrls,
    this.imagesToRemove,
  });

  @override
  List<Object?> get props => [product, newImageFiles, newImageUrls, imagesToRemove];
}

// Delete Product Event
class DeleteProduct extends ProductsEvent {
  final String productId;

  const DeleteProduct({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Update Stock Event
class UpdateProductStock extends ProductsEvent {
  final String productId;
  final int quantity;

  const UpdateProductStock({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

// Search Products Event
class SearchProducts extends ProductsEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

// Filter Products by Category
class FilterProductsByCategory extends ProductsEvent {
  final String? category;

  const FilterProductsByCategory({this.category});

  @override
  List<Object?> get props => [category];
}

// Filter Products by Price Range
class FilterProductsByPriceRange extends ProductsEvent {
  final double minPrice;
  final double maxPrice;

  const FilterProductsByPriceRange({
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

// Sort Products
class SortProducts extends ProductsEvent {
  final String sortBy; // 'name', 'price_low', 'price_high', 'newest'

  const SortProducts({required this.sortBy});

  @override
  List<Object?> get props => [sortBy];
}

// Refresh Products
class RefreshProducts extends ProductsEvent {
 // final String sellerId;

  const RefreshProducts();

  @override
  List<Object?> get props => [];
}

// Clear Filters
class ClearProductFilters extends ProductsEvent {}