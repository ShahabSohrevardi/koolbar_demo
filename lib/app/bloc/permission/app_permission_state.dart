part of 'app_permission_cubit.dart';

@immutable
sealed class AppPermissionState {}

final class AppPermissionInitial extends AppPermissionState {}

final class LocationPermissionGranted extends AppPermissionState {}

final class LocationPermissionDenied extends AppPermissionState {}
