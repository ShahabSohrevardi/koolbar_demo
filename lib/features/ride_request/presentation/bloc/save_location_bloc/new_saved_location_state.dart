part of 'new_saved_location_cubit.dart';

@immutable
sealed class NewSaveLocationState {
  final SavedLocationEntity? savedLocation;
  final String? errorMsg;

  new({this.savedLocation, this.errorMsg});

  factory NewSaveLocationState.success({
    required SavedLocationEntity savedLocation,
  }) = SaveLocationSuccess;

  factory NewSaveLocationState.failed({required String errorMsg}) =
      SavedLocationError;

  factory NewSaveLocationState.loading() = SaveLocationLoading;
}

final class SaveLocationSuccess extends NewSaveLocationState {
  new({required SavedLocationEntity savedLocation})
    : super(savedLocation: savedLocation);
}

final class SavedLocationError extends NewSaveLocationState {
  new({required String errorMsg}) : super(errorMsg: errorMsg);
}

final class SaveLocationLoading extends NewSaveLocationState {}

final class SaveLocationInitial extends NewSaveLocationState {}
