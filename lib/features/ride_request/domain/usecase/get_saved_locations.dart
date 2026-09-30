import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/saved_location_repository.dart';

@LazySingleton(scope: "RideRequest")
class GetSavedLocations {
  final SavedLocationRepository _repository;
  GetSavedLocations(this._repository);
  Future<Resource<List<SavedLocationEntity>>> call() => _repository.getSavedLocations();
}
