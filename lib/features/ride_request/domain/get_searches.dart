import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/address_repository.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

@LazySingleton(scope: "RideRequest")
class GetSearches {
  final AddressRepository _repository;
  new(this._repository);
  Future<Resource<List<SearchEntity>>> call(
    String term,
    Map<String, double> location,
  ) => _repository.getSearches(term, location);
}
