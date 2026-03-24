import 'package:equatable/equatable.dart';

import '../../config/enums/enums.dart';

class AddressModel extends Equatable{

  String addressId;
  String personId;
  String orderId;
  String country;
  String city;
  String street;
  String house;

  AddressModel({
    this.addressId = '',
    this.personId = '',
    this.orderId = '',
    this.country = '',
    this.city = '',
    this.street = '',
    this.house = '',

  });

  AddressModel copyWith ({
    String? newAddressId,
    String? newPersonId,
    String? newOrderId,
    String? newCountry,
    String? newCity,
    String? newStreet,
    String? newHouse
  }) {
    return AddressModel(
      addressId: newAddressId ?? addressId,
      personId: newPersonId ?? personId,
      orderId: newOrderId ?? orderId,
      country: newCountry ?? country,
      city: newCity ?? city,
      street: newStreet ?? street,
      house: newHouse ?? house,
    );
  }

  @override
  List<Object?> get props => [addressId, personId, orderId, country, city, street, house];

}