import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrderModel extends Equatable {
  final String uid;                    // Order ID
  final String orderNumber;            // Human-readable order number
  final String sellerId;               // Seller ID
  final String buyerId;                // Buyer/Customer ID
  final String buyerName;              // Buyer name
  final String buyerEmail;             // Buyer email
  final String buyerPhone;             // Buyer phone number
  final List<OrderItem> items;         // List of ordered items
  final double subtotal;               // Subtotal before tax & shipping
  final double tax;                    // Tax amount
  final double shippingCost;           // Shipping cost
  final double discount;               // Discount amount
  final double totalAmount;            // Total amount after all calculations
  final String status;                 // Order status: pending, processing, shipped, delivered, cancelled, refunded
  final String paymentMethod;          // Payment method: credit_card, paypal, cod, etc.
  final String paymentStatus;          // Payment status: pending, paid, failed, refunded
  final String shippingAddress;        // Shipping address
  final String billingAddress;         // Billing address (optional)
  final String? trackingNumber;        // Shipping tracking number
  final String? shippingCarrier;       // Shipping carrier (UPS, FedEx, etc.)
  final DateTime orderDate;            // Date order was placed
  final DateTime? paymentDate;         // Date payment was processed
  final DateTime? shippingDate;        // Date order was shipped
  final DateTime? deliveryDate;        // Date order was delivered
  final DateTime? cancelledDate;       // Date order was cancelled
  final String? cancellationReason;    // Reason for cancellation
  final String? notes;                 // Additional notes
  final Map<String, dynamic>? metadata; // Additional metadata

  const OrderModel({
    this.uid = '',
    this.orderNumber = '',
    this.sellerId = '',
    this.buyerId = '',
    this.buyerName = '',
    this.buyerEmail = '',
    this.buyerPhone = '',
    this.items = const [],
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.shippingCost = 0.0,
    this.discount = 0.0,
    this.totalAmount = 0.0,
    this.status = 'pending',
    this.paymentMethod = '',
    this.paymentStatus = 'pending',
    this.shippingAddress = '',
    this.billingAddress = '',
    this.trackingNumber,
    this.shippingCarrier,
    required this.orderDate,
    this.paymentDate,
    this.shippingDate,
    this.deliveryDate,
    this.cancelledDate,
    this.cancellationReason,
    this.notes,
    this.metadata,
  });

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isRefunded => status == 'refunded';
  bool get isPaid => paymentStatus == 'paid';
  bool get canCancel => isPending || isProcessing;
  bool get canReturn => isDelivered && DateTime.now().difference(deliveryDate!).inDays <= 30;

  String get formattedOrderNumber => 'ORD-${orderNumber.padLeft(8, '0')}';

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotalWithoutDiscount => subtotal + discount;

  // Create a copy with updated fields
  OrderModel copyWith({
    String? uid,
    String? orderNumber,
    String? sellerId,
    String? buyerId,
    String? buyerName,
    String? buyerEmail,
    String? buyerPhone,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? shippingCost,
    double? discount,
    double? totalAmount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    String? shippingAddress,
    String? billingAddress,
    String? trackingNumber,
    String? shippingCarrier,
    DateTime? orderDate,
    DateTime? paymentDate,
    DateTime? shippingDate,
    DateTime? deliveryDate,
    DateTime? cancelledDate,
    String? cancellationReason,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      uid: uid ?? this.uid,
      orderNumber: orderNumber ?? this.orderNumber,
      sellerId: sellerId ?? this.sellerId,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingCarrier: shippingCarrier ?? this.shippingCarrier,
      orderDate: orderDate ?? this.orderDate,
      paymentDate: paymentDate ?? this.paymentDate,
      shippingDate: shippingDate ?? this.shippingDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      cancelledDate: cancelledDate ?? this.cancelledDate,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }

  // Factory method to create from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      uid: json['uid'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      sellerId: json['sellerId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerEmail: json['buyerEmail'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      items: (json['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      shippingAddress: json['shippingAddress'] ?? '',
      billingAddress: json['billingAddress'] ?? '',
      trackingNumber: json['trackingNumber'],
      shippingCarrier: json['shippingCarrier'],
      orderDate: DateTime.parse(json['orderDate']),
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : null,
      shippingDate: json['shippingDate'] != null
          ? DateTime.parse(json['shippingDate'])
          : null,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      cancelledDate: json['cancelledDate'] != null
          ? DateTime.parse(json['cancelledDate'])
          : null,
      cancellationReason: json['cancellationReason'],
      notes: json['notes'],
      metadata: json['metadata'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'orderNumber': orderNumber,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingCost': shippingCost,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress,
      'billingAddress': billingAddress,
      'trackingNumber': trackingNumber,
      'shippingCarrier': shippingCarrier,
      'orderDate': orderDate.toIso8601String(),
      'paymentDate': paymentDate?.toIso8601String(),
      'shippingDate': shippingDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'cancelledDate': cancelledDate?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'notes': notes,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    uid,
    orderNumber,
    sellerId,
    buyerId,
    buyerName,
    buyerEmail,
    buyerPhone,
    items,
    subtotal,
    tax,
    shippingCost,
    discount,
    totalAmount,
    status,
    paymentMethod,
    paymentStatus,
    shippingAddress,
    billingAddress,
    trackingNumber,
    shippingCarrier,
    orderDate,
    paymentDate,
    shippingDate,
    deliveryDate,
    cancelledDate,
    cancellationReason,
    notes,
    metadata,
  ];
}

// Order Item Model
class OrderItem extends Equatable {
  final String productId;       // Product ID
  final String name;            // Product name at time of purchase
  final String? imageUrl;       // Product image URL
  final double price;           // Price at time of purchase
  final int quantity;           // Quantity ordered
  final double subtotal;        // price * quantity
  final Map<String, dynamic>? specifications; // Product specifications/variants

  const OrderItem({
    required this.productId,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.specifications,
  });

  // Factory method to create from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      specifications: json['specifications'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
      'specifications': specifications,
    };
  }

  OrderItem copyWith({
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    double? subtotal,
    Map<String, dynamic>? specifications,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      specifications: specifications ?? this.specifications,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    imageUrl,
    price,
    quantity,
    subtotal,
    specifications,
  ];
}

// Order Status Enum for better type safety
enum OrderStatus {
  pending('pending', 'Pending', Colors.orange),
  processing('processing', 'Processing', Colors.blue),
  shipped('shipped', 'Shipped', Colors.purple),
  delivered('delivered', 'Delivered', Colors.green),
  cancelled('cancelled', 'Cancelled', Colors.red),
  refunded('refunded', 'Refunded', Colors.grey);

  final String value;
  final String displayName;
  final Color color;

  const OrderStatus(this.value, this.displayName, this.color);

  static OrderStatus fromValue(String value) {
    return OrderStatus.values.firstWhere(
          (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

// Payment Status Enum
enum PaymentStatus {
  pending('pending', 'Pending', Colors.orange),
  paid('paid', 'Paid', Colors.green),
  failed('failed', 'Failed', Colors.red),
  refunded('refunded', 'Refunded', Colors.grey);

  final String value;
  final String displayName;
  final Color color;

  const PaymentStatus(this.value, this.displayName, this.color);

  static PaymentStatus fromValue(String value) {
    return PaymentStatus.values.firstWhere(
          (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

// Payment Method Enum
enum PaymentMethod {
  creditCard('credit_card', 'Credit Card', Icons.credit_card),
  paypal('paypal', 'PayPal', Icons.paypal),
  cod('cod', 'Cash on Delivery', Icons.money),
  bankTransfer('bank_transfer', 'Bank Transfer', Icons.account_balance);

  final String value;
  final String displayName;
  final IconData icon;

  const PaymentMethod(this.value, this.displayName, this.icon);

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
          (method) => method.value == value,
      orElse: () => PaymentMethod.creditCard,
    );
  }
}