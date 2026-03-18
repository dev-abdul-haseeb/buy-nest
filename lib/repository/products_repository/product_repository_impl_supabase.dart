import 'package:ecommerce_shopping_store/Model/product/product_model.dart';
import 'package:ecommerce_shopping_store/repository/products_repository/products_repositroy.dart';

class ProductRepositorySupabase extends ProductsRepository{

  @override
  Future<ProductModel> addProduct(ProductModel product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> addProductToCart(ProductModel product) {
    // TODO: implement addProductToCart
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> fetchProducts() {
    // TODO: implement fetchProducts
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> filterProducts(String category) {
    // TODO: implement filterProducts
    throw UnimplementedError();
  }

  @override
  Future<ProductModel?> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> removeProductFromCart(ProductModel product) {
    // TODO: implement removeProductFromCart
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> sortProducts(String sortBy) {
    // TODO: implement sortProducts
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> updateProductQuantity(ProductModel product, int quantity) {
    // TODO: implement updateProductQuantity
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> updateProductStatus(ProductModel product) {
    // TODO: implement updateProductStatus
    throw UnimplementedError();
  }

}