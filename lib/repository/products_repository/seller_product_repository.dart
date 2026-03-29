import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecommerce_shopping_store/Model/product/product_model.dart';
import 'package:flutter/foundation.dart';

class SellerProductRepository {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Supabase instance
  final SupabaseClient _supabase = Supabase.instance.client;

  // Collection references
  final String _productsCollection = 'products';
  final String _sellersCollection = 'sellers';

  // Storage bucket name for product images
  final String _productImagesBucket = 'Products';

  // Get current seller ID
  String? get _currentSellerId => FirebaseAuth.instance.currentUser?.uid;

  /// Fetch all products for the current seller
  Future<List<ProductModel>> fetchSellerProducts() async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      final QuerySnapshot snapshot = await _firestore
          .collection(_productsCollection)
          .where('sellerId', isEqualTo: sellerId)
          //.orderBy('createdAt', descending: true)
          .get();

      final List<ProductModel> products = snapshot.docs.map((doc) {
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
          imageUrls: List<String>.from(data['imageUrls'] ?? []),

        );
      }).toList();

      return products;
    } catch (e) {
      debugPrint('Error fetching seller products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch a single product by ID
  Future<ProductModel?> fetchProductById(String productId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .get();

      if (!doc.exists) return null;

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
        imageUrls: List<String>.from(data['imageUrls'] ?? []),

      );
    } catch (e) {
      debugPrint('Error fetching product by ID: $e');
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Upload multiple product images to Supabase Storage
  Future<List<String>> uploadProductImages(List<File> imageFiles, String productId) async {
    final List<String> uploadedUrls = [];

    try {
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final String fileExtension = file.path.split('.').last;
        final String fileName = 'products/$productId/${DateTime.now().millisecondsSinceEpoch}_$i.$fileExtension';

        // Read file as bytes
        final Uint8List fileBytes = await file.readAsBytes();

        // Upload to Supabase Storage
        await _supabase.storage
            .from(_productImagesBucket)
            .uploadBinary(fileName, fileBytes);

        // Get public URL
        final String imageUrl = _supabase.storage
            .from(_productImagesBucket)
            .getPublicUrl(fileName);

        uploadedUrls.add(imageUrl);
      }

      return uploadedUrls;
    } catch (e) {
      debugPrint('Error uploading product images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }
  /// Test function to check if a bucket exists in Supabase
  // Future<bool> testBucketExists(String bucketName) async {
  //   try {
  //     final supabase = Supabase.instance.client;
  //     final buckets = await supabase.storage.listBuckets();
  //
  //     final exists = buckets.any((bucket) => bucket.name == bucketName);
  //
  //     if (exists) {
  //       print('✅ Bucket "$bucketName" exists!');
  //       print('   Bucket details:');
  //       final bucket = buckets.firstWhere((b) => b.name == bucketName);
  //       print('   - ID: ${bucket.id}');
  //       print('   - Name: ${bucket.name}');
  //       print('   - Owner: ${bucket.owner}');
  //       print('   - Public: ${bucket.public}');
  //       print('   - Created at: ${bucket.createdAt}');
  //     } else {
  //       print('❌ Bucket "$bucketName" does NOT exist!');
  //       print('   Available buckets: ${buckets.map((b) => b.name).join(', ')}');
  //     }
  //
  //     return exists;
  //   } catch (e) {
  //     print('❌ Error checking bucket: $e');
  //     return false;
  //   }
  // }

  /// Delete product images from Supabase Storage
  Future<void> deleteProductImages(List<String> imageUrls) async {
    try {
      for (String imageUrl in imageUrls) {
        // Extract file path from URL
        final Uri uri = Uri.parse(imageUrl);
        final pathSegments = uri.pathSegments;

        // Find the storage path (after /storage/v1/object/public/product-images/)
        final storageIndex = pathSegments.indexOf(_productImagesBucket);
        if (storageIndex != -1 && storageIndex + 1 < pathSegments.length) {
          final filePath = pathSegments.sublist(storageIndex + 1).join('/');
          await _supabase.storage
              .from(_productImagesBucket)
              .remove([filePath]);
        }
      }
    } catch (e) {
      debugPrint('Error deleting product images: $e');
      // Don't throw, just log the error
    }
  }

  /// Add new product to seller shop
  Future<ProductModel> addProduct({
    required String name,
    required String description,
    required String category,
    required double salePrice,
    required double costPrice,
    required int quantity,
    List<File>? imageFiles,
    List<String>? imageUrls,
  }) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      // Create a temporary product ID
      final DocumentReference productRef = _firestore.collection(_productsCollection).doc();
      final String productId = productRef.id;

      List<String> finalImageUrls = [];

     // Upload images if provided
      if (imageFiles != null && imageFiles.isNotEmpty) {
        finalImageUrls = await uploadProductImages(imageFiles, productId);
      }

      // Add URL-based images
      if (imageUrls != null && imageUrls.isNotEmpty) {
        finalImageUrls.addAll(imageUrls);
      }

//testBucketExists("Products");

      final ProductModel product = ProductModel(
        productId: productId,
        sellerId: sellerId,
        name: name,
        description: description,
        category: category,
        salePrice: salePrice,
        costPrice: costPrice,
        quantity: quantity,
        imageUrls: finalImageUrls,

      );

      // Save to Firestore
      await productRef.set(product.toJson());

      // Update seller's product count
     // await _updateSellerProductCount(sellerId, 1);

      print("Product added successfully: $product");

      return product;
    } catch (e) {
      print("Error adding product: $e");
      debugPrint('Error adding product: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update product in seller shop
  Future<ProductModel> updateProduct({
    required String productId,
    String? name,
    String? description,
    String? category,
    double? salePrice,
    double? costPrice,
    int? quantity,
    List<File>? newImageFiles,
    List<String>? newImageUrls,
    List<String>? imagesToRemove,
  }) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      // Get existing product
      final existingProduct = await fetchProductById(productId);
      if (existingProduct == null) {
        throw Exception('Product not found');
      }

      // Verify ownership
      if (existingProduct.sellerId != sellerId) {
        throw Exception('You do not have permission to update this product');
      }

      List<String> finalImageUrls = List.from(existingProduct.imageUrls);

      // Remove specified images
      if (imagesToRemove != null && imagesToRemove.isNotEmpty) {
        await deleteProductImages(imagesToRemove);
        finalImageUrls.removeWhere((url) => imagesToRemove.contains(url));
      }

      // Upload new images
      if (newImageFiles != null && newImageFiles.isNotEmpty) {
        final newUrls = await uploadProductImages(newImageFiles, productId);
        finalImageUrls.addAll(newUrls);
      }

      // Add URL-based images
      if (newImageUrls != null && newImageUrls.isNotEmpty) {
        finalImageUrls.addAll(newImageUrls);
      }

      final DateTime now = DateTime.now();

      final Map<String, dynamic> updateData = {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (salePrice != null) 'salePrice': salePrice,
        if (costPrice != null) 'costPrice': costPrice,
        if (quantity != null) 'quantity': quantity,
        'imageUrls': finalImageUrls,
        'updatedAt': Timestamp.fromDate(now),
      };

      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .update(updateData);

      // Fetch updated product
      final updatedProduct = await fetchProductById(productId);
      if (updatedProduct == null) {
        throw Exception('Failed to fetch updated product');
      }

      return updatedProduct;
    } catch (e) {
      debugPrint('Error updating product: $e');
      throw Exception('Failed to update product: $e');
    }
  }

  /// Update product stock quantity
  Future<ProductModel> updateProductStock({
    required String productId,
    required int newQuantity,
  }) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      final DateTime now = DateTime.now();

      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .update({
        'quantity': newQuantity,
        'updatedAt': Timestamp.fromDate(now),
      });

      final updatedProduct = await fetchProductById(productId);
      if (updatedProduct == null) {
        throw Exception('Failed to fetch updated product');
      }

      return updatedProduct;
    } catch (e) {
      debugPrint('Error updating product stock: $e');
      throw Exception('Failed to update product stock: $e');
    }
  }

  /// Delete product from seller shop
  Future<bool> deleteProduct(String productId) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      // Get product to verify ownership and delete images
      final product = await fetchProductById(productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      // Verify ownership
      if (product.sellerId != sellerId) {
        throw Exception('You do not have permission to delete this product');
      }

      // Delete product images from storage if exists
      if (product.imageUrls.isNotEmpty) {
        await deleteProductImages(product.imageUrls);
      }

      // Delete product from Firestore
      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .delete();

      // Update seller's product count
      await _updateSellerProductCount(sellerId, -1);

      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Update seller's product count
  Future<void> _updateSellerProductCount(String sellerId, int change) async {
    try {
      final DocumentReference sellerRef = _firestore
          .collection(_sellersCollection)
          .doc(sellerId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(sellerRef);

        if (snapshot.exists) {
          final currentCount = (snapshot.data() as Map<String, dynamic>)['productCount'] ?? 0;
          transaction.update(sellerRef, {
            'productCount': currentCount + change,
            'updatedAt': Timestamp.now(),
          });
        } else {
          transaction.set(sellerRef, {
            'uid': sellerId,
            'productCount': change > 0 ? change : 0,
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      debugPrint('Error updating seller product count: $e');
    }
  }

  /// Search products by name, category, or description
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      final QuerySnapshot snapshot = await _firestore
          .collection(_productsCollection)
          .where('sellerId', isEqualTo: sellerId)
          .get();

      final List<ProductModel> products = snapshot.docs.map((doc) {
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
          imageUrls: List<String>.from(data['imageUrls'] ?? []),

        );
      }).toList();

      // Filter locally for search
      final searchResults = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase());
      }).toList();

      return searchResults;
    } catch (e) {
      debugPrint('Error searching products: $e');
      throw Exception('Failed to search products: $e');
    }
  }

  /// Get low stock products (quantity less than threshold)
  Future<List<ProductModel>> getLowStockProducts({int threshold = 10}) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      final QuerySnapshot snapshot = await _firestore
          .collection(_productsCollection)
          .where('sellerId', isEqualTo: sellerId)
          .where('quantity', isLessThan: threshold)
          .orderBy('quantity', descending: false)
          .get();

      final List<ProductModel> products = snapshot.docs.map((doc) {
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
          imageUrls: List<String>.from(data['imageUrls'] ?? []),

        );
      }).toList();

      return products;
    } catch (e) {
      debugPrint('Error fetching low stock products: $e');
      throw Exception('Failed to fetch low stock products: $e');
    }
  }

  /// Get product statistics for seller
  Future<Map<String, dynamic>> getProductStatistics() async {
    try {
      final products = await fetchSellerProducts();

      final int totalProducts = products.length;
      final int totalStock = products.fold(0, (sum, product) => sum + product.quantity);
      final double totalValue = products.fold(0.0, (sum, product) => sum + (product.salePrice * product.quantity));
      final double totalCost = products.fold(0.0, (sum, product) => sum + (product.costPrice * product.quantity));
      final double potentialProfit = totalValue - totalCost;

      final Map<String, int> categoryCount = {};
      for (var product in products) {
        categoryCount[product.category] = (categoryCount[product.category] ?? 0) + 1;
      }

      return {
        'totalProducts': totalProducts,
        'totalStock': totalStock,
        'totalValue': totalValue,
        'totalCost': totalCost,
        'potentialProfit': potentialProfit,
        'categoryCount': categoryCount,
        'averagePrice': totalProducts > 0 ? totalValue / totalProducts : 0,
      };
    } catch (e) {
      debugPrint('Error getting product statistics: $e');
      throw Exception('Failed to get product statistics: $e');
    }
  }

  /// Stream products in real-time
  Stream<List<ProductModel>> streamSellerProducts() {
    final String? sellerId = _currentSellerId;
    if (sellerId == null) {
      throw Exception('No seller logged in');
    }

    return _firestore
        .collection(_productsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
          productId: doc.id,
          sellerId: data['sellerId'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          salePrice: (data['salePrice'] ?? 0.0).toDouble(),
          costPrice: (data['costPrice'] ?? 0.0).toDouble(),
          quantity: data['quantity'] ?? 0,
          imageUrls: List<String>.from(data['imageUrls'] ?? []),

        );
      }).toList();
    });
  }

  /// Bulk upload products
  Future<List<ProductModel>> bulkUploadProducts(List<Map<String, dynamic>> productsData) async {
    try {
      final String? sellerId = _currentSellerId;
      if (sellerId == null) {
        throw Exception('No seller logged in');
      }

      final List<ProductModel> addedProducts = [];

      final WriteBatch batch = _firestore.batch();

      for (var data in productsData) {
        final DocumentReference productRef = _firestore.collection(_productsCollection).doc();

        final ProductModel product = ProductModel(
          productId: productRef.id,
          sellerId: sellerId,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          salePrice: (data['salePrice'] ?? 0.0).toDouble(),
          costPrice: (data['costPrice'] ?? 0.0).toDouble(),
          quantity: data['quantity'] ?? 0,
          imageUrls: List<String>.from(data['imageUrls'] ?? []),

        );

        batch.set(productRef, product.toJson());
        addedProducts.add(product);
      }

      await batch.commit();

      // Update seller's product count
      await _updateSellerProductCount(sellerId, addedProducts.length);

      return addedProducts;
    } catch (e) {
      debugPrint('Error bulk uploading products: $e');
      throw Exception('Failed to bulk upload products: $e');
    }
  }
}