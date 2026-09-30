import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/saved_location_repository.dart';

@LazySingleton(scope: "RideRequest")
class SaveNewLocation {
  final SavedLocationRepository _repository;
  SaveNewLocation(this._repository);
  Future<Resource<SavedLocationEntity>> call(NewSavedLocationEntity entity) => _repository.saveLocation(entity);
 }
