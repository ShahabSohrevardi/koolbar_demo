import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

abstract class AddressRepository {
  Future<Resource<List<StateEntity>>> getStatesByAddress({
    required String address,
    String? province,
    String? city,
    Map<String, String>? location,
  });

  Future<Resource<AddressEntity>> getAddressByState(double lat, double long);

  Future<Resource<List<SearchEntity>>> getSearches(
    String term,
    Map<String, double> location,
  );
}
