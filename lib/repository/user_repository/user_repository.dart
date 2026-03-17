import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shopping_store/config/enums/enums.dart';

import '../../Model/person/person_model.dart';


class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserInDb(PersonModel person) async {
    await _firestore.collection('person').doc(person.uid).set({
      'cnic': person.cnic,
      'phone': person.phone,
      'name': person.name,
      'role': person.role.name,
      'status': person.status.name,
    });
  }

  Future<PersonModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('person').doc(uid).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return PersonModel(
        uid: uid,
        cnic: data['cnic'],
        phone: data['phone'],
        name: data['name'],
        role: PersonRole.values.firstWhere( // ✅ parse enum from string
              (e) => e.name == data['role'],
          orElse: () => PersonRole.buyer,
        ),
        status: PersonStatus.values.firstWhere( // ✅ parse enum from string
          (e) => e.name == data['status'],
        orElse: () => PersonStatus.waiting,
    ),
      );
    }
    return null;
  }
}