import 'package:bloc/bloc.dart';
import 'package:ecommerce_shopping_store/Model/address/address_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/address_repository/address_repository.dart';

part 'buyer_address_event.dart';
part 'buyer_address_state.dart';

class BuyerAddressBloc extends Bloc<BuyerAddressEvent, BuyerAddressState> {

  AddressRepository _addressRepository = AddressRepository();

  BuyerAddressBloc() : super(BuyerAddressState()) {
    on<GetBuyerAddress>(_getBuyerAddress);
    on<UpdateBuyerAddress>(_updateBuyerAddress);

    add(GetBuyerAddress());
  }

  void _getBuyerAddress (GetBuyerAddress event, Emitter<BuyerAddressState> emit) async {
    String buyerId = event.buyerId;
    if(buyerId == '') {
      buyerId = FirebaseAuth.instance.currentUser!.uid;
    }
    AddressModel newModel = await _addressRepository.getBuyerAddressById(buyerId);
    emit(state.copyWith(newAddressModel: newModel));
  }

  void _updateBuyerAddress(UpdateBuyerAddress event, Emitter<BuyerAddressState> emit) async {
    AddressModel newModel = AddressModel(
      house: event.house,
      street: event.street,
      city: event.city,
      country: event.country,
    );
    String buyerId = event.buyerId;
    if (buyerId == '') {
      buyerId = FirebaseAuth.instance.currentUser!.uid;
    }
    AddressModel updatedModel = await _addressRepository.updateBuyerAddress(newModel, buyerId);
    emit(state.copyWith(newAddressModel: updatedModel));
  }
}