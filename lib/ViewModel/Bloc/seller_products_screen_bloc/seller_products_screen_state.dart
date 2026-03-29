part of 'seller_products_screen_bloc.dart';


class ProductsState extends Equatable {
  final ProductScreenStatus status;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final String? errorMessage;
  final String? searchQuery;
  final String? selectedCategory;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;
  final int totalProducts;
  final double totalValue;
  final Map<String, int> categoryCounts;


  const ProductsState({
    this.status = ProductScreenStatus.initial,
    this.products = const [],
    this.filteredProducts = const [],
    this.errorMessage,
    this.searchQuery,
    this.selectedCategory,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.totalProducts = 0,
    this.totalValue = 0.0,
    this.categoryCounts = const {},
  });

  // Helper getters
  bool get isLoading => status == ProductScreenStatus.loading;
  bool get isAdding => status == ProductScreenStatus.adding;
  bool get isUpdating => status == ProductScreenStatus.updating;
  bool get isDeleting => status == ProductScreenStatus.deleting;
  bool get hasError => status == ProductScreenStatus.error;
  bool get isEmpty => status == ProductScreenStatus.empty;
  bool get isLoaded => status == ProductScreenStatus.loaded;

  // Get displayed products (filtered or all)
  List<ProductModel> get displayProducts =>
      filteredProducts.isNotEmpty ? filteredProducts : products;

  // Get low stock products (quantity < 10)
  List<ProductModel> get lowStockProducts =>
      products.where((product) => product.quantity < 10).toList();

  // Get out of stock products
  List<ProductModel> get outOfStockProducts =>
      products.where((product) => product.quantity == 0).toList();

  // Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  // Get total value of all products
  double getTotalInventoryValue() {
    return products.fold(0.0, (sum, product) => sum + (product.costPrice * product.quantity));
  }

  // Get potential profit (salePrice - costPrice) * quantity
  double getPotentialProfit() {
    return products.fold(0.0, (sum, product) =>
    sum + ((product.salePrice - product.costPrice) * product.quantity));
  }

  // Get average product price
  double getAveragePrice() {
    if (products.isEmpty) return 0.0;
    return products.fold(0.0, (sum, product) => sum + product.salePrice) / products.length;
  }

  ProductsState copyWith({
    ProductScreenStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? totalProducts,
    double? totalValue,
    Map<String, int>? categoryCounts,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      totalProducts: totalProducts ?? this.totalProducts,
      totalValue: totalValue ?? this.totalValue,
      categoryCounts: categoryCounts ?? this.categoryCounts,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    filteredProducts,
    errorMessage,
    searchQuery,
    selectedCategory,
    minPrice,
    maxPrice,
    sortBy,
    totalProducts,
    totalValue,
    categoryCounts,
  ];
}