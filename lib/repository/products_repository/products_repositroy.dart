import 'package:ecommerce_shopping_store/Model/product/product_model.dart';

abstract class ProductsRepository {

    Future<List<ProductModel>> fetchProducts() ;
    Future<ProductModel?> getProductById(String id);
    Future<List<ProductModel>> searchProducts(String query) ;
    Future<List<ProductModel>> filterProducts(String category) ;
    Future<List<ProductModel>> sortProducts(String sortBy) ;
    Future<ProductModel> addProduct(ProductModel product) ;
    Future<ProductModel> updateProduct(ProductModel product);
    Future<ProductModel> addProductToCart(ProductModel product) ;
    Future<ProductModel> removeProductFromCart(ProductModel product) ;
    Future<ProductModel> updateProductQuantity(ProductModel product, int quantity);
    Future<ProductModel> updateProductStatus(ProductModel product);



}