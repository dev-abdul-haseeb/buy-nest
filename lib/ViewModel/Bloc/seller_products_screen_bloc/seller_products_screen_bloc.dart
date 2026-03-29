import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_shopping_store/Model/product/product_model.dart';

import '../../../config/enums/enums.dart';
import '../../../repository/products_repository/seller_product_repository.dart';

part 'seller_products_screen_events.dart';
part 'seller_products_screen_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final SellerProductRepository _repository;

  ProductsBloc({required SellerProductRepository repository})
      : _repository = repository,
        super(const ProductsState()) {
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
    emit(state.copyWith(status: ProductScreenStatus.loading));

    try {
      final List<ProductModel> products = await _repository.fetchSellerProducts();

      // Calculate category counts
      final Map<String, int> categoryCounts = {};
      for (var product in products) {
        categoryCounts[product.category] = (categoryCounts[product.category] ?? 0) + 1;
      }

      final totalValue = products.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      if (products.isEmpty) {
        emit(state.copyWith(
          status: ProductScreenStatus.empty,
          products: [],
          filteredProducts: [],
          totalProducts: 0,
          totalValue: 0,
          categoryCounts: {},
        ));
      } else {
        emit(state.copyWith(
          status: ProductScreenStatus.loaded,
          products: products,
          filteredProducts: [],
          totalProducts: products.length,
          totalValue: totalValue,
          categoryCounts: categoryCounts,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to load products: ${error.toString()}',
      ));
    }
  }

  // Add Product
  Future<void> _onAddProduct(
      AddProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductScreenStatus.adding));

    try {
      // Add product to repository
      final ProductModel newProduct = await _repository.addProduct(
        name: event.product.name,
        description: event.product.description,
        category: event.product.category,
        salePrice: event.product.salePrice,
        costPrice: event.product.costPrice,
        quantity: event.product.quantity,
        imageFiles: event.imageFiles,
        imageUrls: event.imageUrls,
      );

      final updatedProducts = List<ProductModel>.from(state.products)..add(newProduct);
      final totalValue = updatedProducts.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      // Update category counts
      final Map<String, int> categoryCounts = Map.from(state.categoryCounts);
      categoryCounts[newProduct.category] = (categoryCounts[newProduct.category] ?? 0) + 1;

      emit(state.copyWith(
        status: ProductScreenStatus.added,
        products: updatedProducts,
        totalProducts: updatedProducts.length,
        totalValue: totalValue,
        categoryCounts: categoryCounts,
      ));

      // Reset status after a delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductScreenStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to add product: ${error.toString()}',
      ));
    }
  }

  // Update Product
  Future<void> _onUpdateProduct(
      UpdateProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductScreenStatus.updating));

    try {
      // Update product in repository
      final ProductModel updatedProduct = await _repository.updateProduct(
        productId: event.product.productId,
        name: event.product.name,
        description: event.product.description,
        category: event.product.category,
        salePrice: event.product.salePrice,
        costPrice: event.product.costPrice,
        quantity: event.product.quantity,
        newImageFiles: event.newImageFiles,
        newImageUrls: event.newImageUrls,
        imagesToRemove: event.imagesToRemove,
      );

      final updatedProducts = state.products.map((product) {
        if (product.productId == updatedProduct.productId) {
          return updatedProduct;
        }
        return product;
      }).toList();

      final totalValue = updatedProducts.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));

      emit(state.copyWith(
        status: ProductScreenStatus.updated,
        products: updatedProducts,
        totalValue: totalValue,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductScreenStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to update product: ${error.toString()}',
      ));
    }
  }

  // Delete Product
  Future<void> _onDeleteProduct(
      DeleteProduct event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductScreenStatus.deleting));

    try {
      // Get product before deletion for category count update
      final productToDelete = state.products.firstWhere(
            (product) => product.productId == event.productId,
        orElse: () => const ProductModel(),
      );

      // Delete product from repository
      final bool deleted = await _repository.deleteProduct(event.productId);

      if (deleted) {
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
          status: ProductScreenStatus.deleted,
          products: updatedProducts,
          totalProducts: updatedProducts.length,
          totalValue: totalValue,
          categoryCounts: categoryCounts,
        ));

        if (updatedProducts.isEmpty) {
          emit(state.copyWith(status: ProductScreenStatus.empty));
        } else {
          await Future.delayed(const Duration(milliseconds: 500));
          emit(state.copyWith(status: ProductScreenStatus.loaded));
        }
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to delete product: ${error.toString()}',
      ));
    }
  }

  // Update Product Stock
  Future<void> _onUpdateProductStock(
      UpdateProductStock event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(status: ProductScreenStatus.updating));

    try {
      // Update stock in repository
      final ProductModel updatedProduct = await _repository.updateProductStock(
        productId: event.productId,
        newQuantity: event.quantity,
      );

      final updatedProducts = state.products.map((product) {
        if (product.productId == event.productId) {
          return updatedProduct;
        }
        return product;
      }).toList();

      final totalValue = updatedProducts.fold(0.0, (double sum, ProductModel product) =>
      sum + (product.salePrice * product.quantity));

      emit(state.copyWith(
        status: ProductScreenStatus.updated,
        products: updatedProducts,
        totalValue: totalValue,
      ));

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ProductScreenStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to update stock: ${error.toString()}',
      ));
    }
  }

  // Search Products
  Future<void> _onSearchProducts(
      SearchProducts event,
      Emitter<ProductsState> emit,
      ) async {
    emit(state.copyWith(
      status: ProductScreenStatus.searching,
      searchQuery: event.query,
    ));

    try {
      if (event.query.isEmpty) {
        // Clear search
        emit(state.copyWith(
          filteredProducts: [],
          status: ProductScreenStatus.loaded,
        ));
      } else {
        // Search products using repository
        final searchResults = await _repository.searchProducts(event.query);

        emit(state.copyWith(
          filteredProducts: searchResults,
          status: searchResults.isEmpty ? ProductScreenStatus.empty : ProductScreenStatus.loaded,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: ProductScreenStatus.error,
        errorMessage: 'Failed to search products: ${error.toString()}',
      ));
    }
  }

  // Filter Products by Category
  void _onFilterProductsByCategory(
      FilterProductsByCategory event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductScreenStatus.filtering,
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
      status: filtered.isEmpty ? ProductScreenStatus.empty : ProductScreenStatus.loaded,
    ));
  }

  // Filter Products by Price Range
  void _onFilterProductsByPriceRange(
      FilterProductsByPriceRange event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductScreenStatus.filtering,
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
      status: filtered.isEmpty ? ProductScreenStatus.empty : ProductScreenStatus.loaded,
    ));
  }

  // Sort Products
  void _onSortProducts(
      SortProducts event,
      Emitter<ProductsState> emit,
      ) {
    emit(state.copyWith(
      status: ProductScreenStatus.filtering,
      sortBy: event.sortBy,
    ));

    List<ProductModel> productsToSort = state.filteredProducts.isNotEmpty
        ? state.filteredProducts
        : List.from(state.products);

    final sortedProducts = _applySorting(productsToSort, event.sortBy);

    emit(state.copyWith(
      filteredProducts: sortedProducts,
      status: ProductScreenStatus.loaded,
    ));
  }

  List<ProductModel> _applySorting(List<ProductModel> products, String sortBy) {
    final sortedList = List<ProductModel>.from(products);
    switch (sortBy) {
      case 'name':
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        sortedList.sort((a, b) => a.salePrice.compareTo(b.salePrice));
        break;
      case 'price_high':
        sortedList.sort((a, b) => b.salePrice.compareTo(a.salePrice));
        break;
      case 'newest':
        sortedList.sort((a, b) => b.productId.compareTo(a.productId));
        break;
      case 'stock_low':
        sortedList.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case 'stock_high':
        sortedList.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      default:
        break;
    }
    return sortedList;
  }

  // Refresh Products
  Future<void> _onRefreshProducts(
      RefreshProducts event,
      Emitter<ProductsState> emit,
      ) async {
    add(LoadProducts());
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
      status: ProductScreenStatus.loaded,
    ));
  }
}