import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/address_repository.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

@LazySingleton(scope:"RideRequest")
class GetAddressesFromState {
  final AddressRepository _repository;
  new({required this._repository});
  Future<Resource<AddressEntity>> call(double lat, double long) => _repository.getAddressByState(lat, long);
}