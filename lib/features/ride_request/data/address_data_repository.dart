import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/data/address_cloud_data_source.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/address_repository.dart';

@LazySingleton(scope: "RideRequest",as: AddressRepository)
class AddressDataRepository extends AddressRepository {
  final AddressCloudDataSource _cloudDataSource;

  new(this._cloudDataSource);

  @override
  Future<Resource<AddressEntity>> getAddressByState(
    double lat,
    double long,
  ) async {
    try {
      final res = await _cloudDataSource.getAddressByState(lat, long);
      return Resource.success(res.toEntity());
    } catch (e) {
      return Resource.failed(e.toString());
    }
  }

  @override
  Future<Resource<List<StateEntity>>> getStatesByAddress({
    required String address,
    String? province,
    String? city,
    Map<String, String>? location,
  }) async {
    try {
      final res = await _cloudDataSource.getStatesByAddress(
        address: address,
        province: province,
        city: city,
        location: location,
      );
      return Resource.success(res.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Resource.failed(e.toString());
    }
  }

  @override
  Future<Resource<List<SearchEntity>>> getSearches(
    String term,
    Map<String, double> location,
  ) async {
    try {
      final res = await _cloudDataSource.getSearches(term, location);
      return Resource.success(res.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Resource.failed(e.toString());
    }
  }
}
