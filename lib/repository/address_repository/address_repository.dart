import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shopping_store/Model/address/address_model.dart';

class AddressRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<AddressModel> getBuyerAddressById(String buyerId) async {
    final snapshot = await _firestore
        .collection('address')
        .where('personId', isEqualTo: buyerId)
        .where('orderId', isEqualTo: '')   // user address has no orderId
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return const AddressModel(); // no address yet — handled

    final doc = snapshot.docs.first;
    return AddressModel(
      addressId: doc.id,
      personId: doc['personId'],
      orderId: '',
      city: doc['city'],
      country: doc['country'],
      house: doc['house'],
      street: doc['street'],
    );
  }

  Future<AddressModel> updateBuyerAddress(AddressModel newAddress, String buyerId) async {
    final snapshot = await _firestore
        .collection('address')
        .where('personId', isEqualTo: buyerId)
        .where('orderId', isEqualTo: '')
        .limit(1)
        .get();

    final addressData = {
      'personId': buyerId,
      'orderId': '',
      'house': newAddress.house,
      'street': newAddress.street,
      'city': newAddress.city,
      'country': newAddress.country,
    };

    if (snapshot.docs.isEmpty) {
      final docRef = await _firestore.collection('address').add(addressData);
      return newAddress.copyWith(newAddressId: docRef.id, newPersonId: buyerId);
    } else {
      // Address exists — update it
      final docId = snapshot.docs.first.id;
      await _firestore.collection('address').doc(docId).update(addressData);
      return newAddress.copyWith(newAddressId: docId, newPersonId: buyerId);
    }
  }}