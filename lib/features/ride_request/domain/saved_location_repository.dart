import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

abstract class SavedLocationRepository {
 Future<Resource<List<SavedLocationEntity>>> getSavedLocations();
 Future<Resource<SavedLocationEntity>> saveLocation(NewSavedLocationEntity location);
}