import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/get_addresses_from_state.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:meta/meta.dart';
import 'package:koolbar_demo/core/common/resource.dart';

part 'location_to_address_state.dart';

@Injectable(scope: "RideRequest")
class LocationToAddressCubit extends Cubit<LocationToAddressState> {
  final GetAddressesFromState _getAddressesFromState;

  LocationToAddressCubit(this._getAddressesFromState)
    : super(LocationToAddressInitial());

  void sendLocation(double latitude, double longitude) async {
    emit(LocationToAddressState.loading());
    final res = await _getAddressesFromState(latitude, longitude);
    switch (res.status) {
      case ResourceStatus.Success:
        emit(LocationToAddressState.loaded(entity: res.data!));
        break;
      case ResourceStatus.Failed:
        emit(LocationToAddressState.failed(errorMsg: res.message!));
        break;
      default:
        emit(LocationToAddressState.initial());
        break;
    }
  }
}
