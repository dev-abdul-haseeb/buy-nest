import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_shopping_store/Model/product/product_model.dart';

part 'seller_products_screen_events.dart';
part 'seller_products_screen_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsState()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProductStock>(_onUpdateProductStock);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<FilterProductsByPriceRange>(_onFilterProductsByPriceRange);
    on<SortProducts>(_onSortProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<ClearProductFilters>(_onClearProductFilters);
  }

  // Load Products
  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    try {
      // TODO: Replace with actual API call
      // final products = await productRepository.getSellerProducts(event.sellerId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      final List<ProductModel> products = [];

      // Calculate category counts
      final Map<String, int> categoryCounts = {};
      for (var product in products) {
        categoryCounts[product.category] = (categoryCounts[product.category] ?? 0) + 1;
      }

      final totalValue = products.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      if (products.isEmpty) {
        emit(state.copyWith(
          status: ProductsStatus.empty,
          products: [],
          filteredProducts: [],
          totalProducts: 0,
          totalValue: 0,
          categoryCounts: {},
        ));
      } else {
        emit(state.copyWith(
          status: ProductsStatus.loaded,
          products: products,
          filteredProducts: [],
          totalProducts: products.length,
          totalValue: totalValue,
          categoryCounts: categoryCounts,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to load products: ${error.toString()}',
      ));
    }
  }

  // Add Product
  Future<void> _onAddProduct(
      AddProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductsStatus.adding));

    try {
      // TODO: Upload image if exists
      // String? uploadedImageUrl;
      // if (event.imageFile != null) {
      //   uploadedImageUrl = await uploadImage(event.imageFile!);
      // } else if (event.imageUrl != null) {
      //   uploadedImageUrl = event.imageUrl;
      // }

      // TODO: Save product to database
      // final productWithImage = event.product.copyWith(imageUrl: uploadedImageUrl);
      // await productRepository.addProduct(productWithImage);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedProducts = List<ProductModel>.from(state.products)..add(event.product);
      final totalValue = updatedProducts.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      // Update category counts
      final Map<String, int> categoryCounts = Map.from(state.categoryCounts);
      categoryCounts[event.product.category] = (categoryCounts[event.product.category] ?? 0) + 1;

      emit(state.copyWith(
        status: ProductsStatus.added,
        products: updatedProducts,
        totalProducts: updatedProducts.length,
        totalValue: totalValue,
        categoryCounts: categoryCounts,
      ));

      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductsStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to add product: ${error.toString()}',
      ));
    }
  }

  // Update Product
  Future<void> _onUpdateProduct(
      UpdateProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductsStatus.updating));

    try {
      // TODO: Upload new image if exists
      // String? uploadedImageUrl;
      // if (event.imageFile != null) {
      //   uploadedImageUrl = await uploadImage(event.imageFile!);
      // } else if (event.imageUrl != null) {
      //   uploadedImageUrl = event.imageUrl;
      // }

      // TODO: Update product in database
      // final updatedProduct = event.product.copyWith(imageUrl: uploadedImageUrl);
      // await productRepository.updateProduct(updatedProduct);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedProducts = state.products.map((product) {
        if (product.productId == event.product.productId) {
          return event.product;
        }
        return product;
      }).toList();

      final totalValue = updatedProducts.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      emit(state.copyWith(
        status: ProductsStatus.updated,
        products: updatedProducts,
        totalValue: totalValue,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductsStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to update product: ${error.toString()}',
      ));
    }
  }

  // Delete Product
  Future<void> _onDeleteProduct(
      DeleteProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductsStatus.deleting));

    try {
      // TODO: Delete product from database
      // await productRepository.deleteProduct(event.productId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final productToDelete = state.products.firstWhere(
            (product) => product.productId == event.productId,
        orElse: () => const ProductModel(),
      );

      final updatedProducts = state.products
          .where((product) => product.productId != event.productId)
          .toList();

      final totalValue = updatedProducts.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      // Update category counts
      final Map<String, int> categoryCounts = Map.from(state.categoryCounts);
      if (productToDelete.category.isNotEmpty) {
        categoryCounts[productToDelete.category] =
            (categoryCounts[productToDelete.category] ?? 1) - 1;
        if (categoryCounts[productToDelete.category] == 0) {
          categoryCounts.remove(productToDelete.category);
        }
      }

      emit(state.copyWith(
        status: ProductsStatus.deleted,
        products: updatedProducts,
        totalProducts: updatedProducts.length,
        totalValue: totalValue,
        categoryCounts: categoryCounts,
      ));

      if (updatedProducts.isEmpty) {
        emit(state.copyWith(status: ProductsStatus.empty));
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(status: ProductsStatus.loaded));
      }
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to delete product: ${error.toString()}',
      ));
    }
  }

  // Update Product Stock
  Future<void> _onUpdateProductStock(
      UpdateProductStock event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductsStatus.updating));

    try {
      // TODO: Update stock in database
      // await productRepository.updateStock(event.productId, event.quantity);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedProducts = state.products.map((product) {
        if (product.productId == event.productId) {
          return product.copyWith(quantity: event.quantity);
        }
        return product;
      }).toList();

      // Fixed: Properly typed fold operation
      final totalValue = updatedProducts.fold(0.0, (double sum, ProductModel product) =>
      sum + (product.salePrice * product.quantity)
      );

      emit(state.copyWith(
        status: ProductsStatus.updated,
        products: updatedProducts,
        totalValue: totalValue,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductsStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: 'Failed to update stock: ${error.toString()}',
      ));
    }
  }

  // Search Products
  void _onSearchProducts(
      SearchProducts event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductsStatus.searching,
      searchQuery: event.query,
    ));

    if (event.query.isEmpty) {
      // Clear search
      emit(state.copyWith(
        filteredProducts: [],
        status: ProductsStatus.loaded,
      ));
    } else {
      // Search in products
      final searchResults = state.products.where((product) {
        return product.name.toLowerCase().contains(event.query.toLowerCase()) ||
            product.description.toLowerCase().contains(event.query.toLowerCase()) ||
            product.category.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(state.copyWith(
        filteredProducts: searchResults,
        status: searchResults.isEmpty ? ProductsStatus.empty : ProductsStatus.loaded,
      ));
    }
  }

  // Filter Products by Category
  void _onFilterProductsByCategory(
      FilterProductsByCategory event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductsStatus.filtering,
      selectedCategory: event.category,
    ));

    List<ProductModel> filtered = List.from(state.products);

    if (event.category != null && event.category!.isNotEmpty) {
      filtered = filtered.where((product) => product.category == event.category).toList();
    }

    // Apply existing price filter if any
    if (state.minPrice != null && state.maxPrice != null) {
      filtered = filtered.where((product) =>
      product.salePrice >= state.minPrice! &&
          product.salePrice <= state.maxPrice!
      ).toList();
    }

    // Apply existing sort if any
    if (state.sortBy != null) {
      filtered = _applySorting(filtered, state.sortBy!);
    }

    emit(state.copyWith(
      filteredProducts: filtered,
      status: filtered.isEmpty ? ProductsStatus.empty : ProductsStatus.loaded,
    ));
  }

  // Filter Products by Price Range
  void _onFilterProductsByPriceRange(
      FilterProductsByPriceRange event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductsStatus.filtering,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
    ));

    List<ProductModel> filtered = List.from(state.products);

    // Apply category filter if active
    if (state.selectedCategory != null && state.selectedCategory!.isNotEmpty) {
      filtered = filtered.where((product) => product.category == state.selectedCategory).toList();
    }

    // Apply price filter
    filtered = filtered.where((product) =>
    product.salePrice >= event.minPrice &&
        product.salePrice <= event.maxPrice
    ).toList();

    // Apply existing sort if any
    if (state.sortBy != null) {
      filtered = _applySorting(filtered, state.sortBy!);
    }

    emit(state.copyWith(
      filteredProducts: filtered,
      status: filtered.isEmpty ? ProductsStatus.empty : ProductsStatus.loaded,
    ));
  }

  // Sort Products
  void _onSortProducts(
      SortProducts event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductsStatus.filtering,
      sortBy: event.sortBy,
    ));

    List<ProductModel> productsToSort = state.filteredProducts.isNotEmpty
        ? state.filteredProducts
        : List.from(state.products);

    final sortedProducts = _applySorting(productsToSort, event.sortBy);

    emit(state.copyWith(
      filteredProducts: sortedProducts,
      status: ProductsStatus.loaded,
    ));
  }

  List<ProductModel> _applySorting(List<ProductModel> products, String sortBy) {
    switch (sortBy) {
      case 'name':
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        products.sort((a, b) => a.salePrice.compareTo(b.salePrice));
        break;
      case 'price_high':
        products.sort((a, b) => b.salePrice.compareTo(a.salePrice));
        break;
      case 'newest':
        products.sort((a, b) => b.productId.compareTo(a.productId));
        break;
      case 'stock_low':
        products.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case 'stock_high':
        products.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      default:
        break;
    }
    return products;
  }

  // Refresh Products
  Future<void> _onRefreshProducts(
      RefreshProducts event,
      Emitter<ProductsState> emit,
      ) async {
    add(LoadProducts(sellerId: event.sellerId));
  }

  // Clear Filters
  void _onClearProductFilters(
      ClearProductFilters event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      filteredProducts: [],
      searchQuery: null,
      selectedCategory: null,
      minPrice: null,
      maxPrice: null,
      sortBy: null,
      status: ProductsStatus.loaded,
    ));
  }
}