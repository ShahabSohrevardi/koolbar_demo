part of 'new_saved_location_cubit.dart';

@immutable
sealed class NewSaveLocationState {
  final SavedLocationEntity? savedLocation;
  final String? errorMsg;

  const NewSaveLocationState({this.savedLocation, this.errorMsg});

  const factory NewSaveLocationState.success({
    required SavedLocationEntity savedLocation,
  }) = NewSaveLocationSuccess;

  const factory NewSaveLocationState.failed({required String errorMsg}) =
      NewSavedLocationError;

  factory NewSaveLocationState.loading() = NewSaveLocationLoading;
}

final class NewSaveLocationSuccess extends NewSaveLocationState {
  const NewSaveLocationSuccess({required SavedLocationEntity savedLocation})
    : super(savedLocation: savedLocation);
}

final class NewSavedLocationError extends NewSaveLocationState {
  const NewSavedLocationError({required String errorMsg}) : super(errorMsg: errorMsg);
}

final class NewSaveLocationLoading extends NewSaveLocationState {}

final class NewSaveLocationInitial extends NewSaveLocationState {}
