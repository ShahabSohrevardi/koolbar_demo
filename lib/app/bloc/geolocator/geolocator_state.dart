part of 'geolocator_cubit.dart';

@immutable
sealed class GeolocatorState extends Equatable{
  final double? latitude;
  final double? longitude;
  final String? errorMsg;

  new({this.latitude, this.longitude, this.errorMsg});

  @override
  // TODO: implement props
  List<Object?> get props => [latitude, longitude, errorMsg];
}

final class GeolocatorLoading extends GeolocatorState {}

final class GeolocatorSuccess extends GeolocatorState {
  new({required double latitude, required double longitude})
    : super(latitude: latitude, longitude: longitude);
}

final class GeolocatorError extends GeolocatorState {
  new({required String errorMsg}) : super(errorMsg: errorMsg);
}

final class GeolocatorInitial extends GeolocatorState {}
