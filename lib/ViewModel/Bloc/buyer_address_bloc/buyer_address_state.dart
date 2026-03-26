part of 'buyer_address_bloc.dart';

class BuyerAddressState extends Equatable {

  AddressModel addressModel;

  BuyerAddressState ({
    this.addressModel = const AddressModel()
  });

  BuyerAddressState copyWith({AddressModel? newAddressModel}) {
    return BuyerAddressState(
      addressModel: newAddressModel ?? this.addressModel,
    );
  }

  @override
  List<Object?> get props => [addressModel];

}