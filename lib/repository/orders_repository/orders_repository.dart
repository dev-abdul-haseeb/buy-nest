import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersRepository {

  Future<int> getOrderCountByBuyer(String buyerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

}