import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

import 'address_repository.dart';

@LazySingleton(scope: "RideRequest")
class GetStatesFromAdress {
  final AddressRepository _repository;

  new({required this._repository});

  Future<Resource<List<StateEntity>>> call({
    required String address,
    String? province,
    String? city,
    Map<String, double>? location,
  }) => _repository.getStatesByAddress(
    address: address,
    province: province,
    city: city,
    location: location,
  );
}
