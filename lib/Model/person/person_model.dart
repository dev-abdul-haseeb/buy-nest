import 'package:equatable/equatable.dart';

import '../../config/enums/enums.dart';

class PersonModel extends Equatable{
  final String uid;
  final String cnic;
  final String phone;
  final String name;
  final PersonRole role;
  final String email;
  final String password;
  final PersonStatus status;

  const PersonModel({
    this.uid = '',
    this.cnic = '',
    this.phone = '',
    this.name = '',
    this.role = PersonRole.buyer,
    this.email = '',
    this.password = '',
    this.status = PersonStatus.waiting
  });

  PersonModel copyWith ({String? newUid, String? newCnic, String? newPhone, String? newName, PersonRole? newRole, String? newEmail, String? newPassword, PersonStatus? newStatus}) {
    return PersonModel(
      uid: newUid ?? this.uid,
      cnic: newCnic ?? this.cnic,
      phone: newPhone ?? this.phone,
      name: newName ?? this.name,
      role: newRole ?? this.role,
      email: newEmail ?? this.email,
      password: newPassword ?? this.password,
      status: newStatus ?? this.status
    );
  }

  @override
  List<Object?> get props => [uid, cnic, phone, name, role, email, password, status];

}