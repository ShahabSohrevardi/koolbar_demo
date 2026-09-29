import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/features/ride_request/data/dao.dart';
import 'package:koolbar_demo/features/ride_request/data/models.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

@LazySingleton(scope: "RideRequest")
class SavedLocationLocalDataSource {
  final SavedLocationDao _dao;

  new({required this._dao});

  Future<String> save(NewSavedLocationEntity entity) =>
      _dao.save(SavedLocation.fromEntity(entity));

  Future<List<SavedLocationEntity>> getSavedLocations() async =>
      (await _dao.getSavedLocations()).map((e) => e.toEntity()).toList();

  Future<SavedLocationEntity?> findByID(String id) async =>
      (await _dao.findByID(id))?.toEntity();
}
