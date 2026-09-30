import 'package:hive_ce/hive.dart';
import 'package:koolbar_demo/core/db/hive_types.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

part 'models.g.dart';

@HiveType(typeId: savedLocation)
class SavedLocation {
  @HiveField(2)
  final String name;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;
  @HiveField(5)
  final int? iconCodePoint;

  SavedLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.iconCodePoint,
  });

  factory SavedLocation.fromEntity(NewSavedLocationEntity entity) =>
      SavedLocation(
        name: entity.name,
        latitude: entity.latitude,
        longitude: entity.longitude,
        iconCodePoint: entity.iconCodePoint,
      );

  SavedLocationEntity toEntity() => SavedLocationEntity(
    name: name,
    latitude: latitude,
    longitude: longitude,
    iconCodePoint: iconCodePoint,
  );
}
