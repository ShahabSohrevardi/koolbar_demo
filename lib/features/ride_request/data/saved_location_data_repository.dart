import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/data/saved_location_local_data_source.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/saved_location_repository.dart';

@LazySingleton(scope: "RideRequest", as: SavedLocationRepository)
class SavedLocationDataRepository extends SavedLocationRepository {
  final SavedLocationLocalDataSource _localDataSource;

  new(this._localDataSource);

  @override
  Future<Resource<List<SavedLocationEntity>>> getSavedLocations() async {
    try {
      final res = await _localDataSource.getSavedLocations();
      return Resource.success(res);
    } catch (e) {
      return Resource.failed(e.toString());
    }
  }

  @override
  Future<Resource<SavedLocationEntity>> saveLocation(
    NewSavedLocationEntity location,
  ) async {
    try {
      final newID = await _localDataSource.save(location);
      final res = await _localDataSource.findByID(newID);
      return Resource.success(res!);
    } catch (e) {
      return Resource.failed(e.toString());
    }
  }
}
