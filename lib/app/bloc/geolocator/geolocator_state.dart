part of 'geolocator_cubit.dart';

@immutable
sealed class GeolocatorState {}
final class GeolocatorLoading extends GeolocatorState {}
final class GeolocatorSuccess extends GeolocatorState {
  final double latitude;
  final double longitude;
  new({required this.latitude, required this.longitude});
}
final class GeolocatorError extends GeolocatorState {
  final String message;
  new({required this.message});
}

final class GeolocatorInitial extends GeolocatorState {}
