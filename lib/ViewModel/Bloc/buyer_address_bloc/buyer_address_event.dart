part of 'buyer_address_bloc.dart';

abstract class BuyerAddressEvent extends Equatable {

  BuyerAddressEvent();

  @override
  List<Object?> get props => [];
}

class GetBuyerAddress extends BuyerAddressEvent {
  String buyerId;

  GetBuyerAddress ({
    this.buyerId = ''
  });
}

class UpdateBuyerAddress extends BuyerAddressEvent {
  String house;
  String street;
  String city;
  String country;
  String buyerId;

  UpdateBuyerAddress ({
    this.house = '',
    this.street = '',
    this.city = '',
    this.country = '',
    this.buyerId = ''
  });

  @override
  List<Object?> get props => [house, street, city, country, buyerId];

}