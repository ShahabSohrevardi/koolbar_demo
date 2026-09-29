part of 'saved_locations_cubit.dart';

@immutable
class SavedLocationsState extends Equatable {
  final List<SavedLocationEntity>? savedLocations;
  final String? errorMsg;
  const new({this.savedLocations, this.errorMsg});

  const factory SavedLocationsState.success(
    List<SavedLocationEntity> savedLocations,
  ) = SavedLocationsLoaded;

  const factory SavedLocationsState.failed({required String errorMsg}) =
      SavedLocationFailed;

  const factory SavedLocationsState.loading() = SavedLocationsLoading;

  SavedLocationsState copyWith({
    List<SavedLocationEntity>? savedLocations,
    String? errorMsg,
  }) => SavedLocationsState(
    savedLocations: this.savedLocations ?? savedLocations,
    errorMsg: this.errorMsg ?? errorMsg,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [savedLocations?.length ?? 0, errorMsg];
}

final class SavedLocationsLoaded extends SavedLocationsState {
  const new(List<SavedLocationEntity> savedLocations)
    : super(savedLocations: savedLocations);
}

final class SavedLocationFailed extends SavedLocationsState {
  const new({required String errorMsg}) : super(errorMsg: errorMsg);
}

final class SavedLocationsLoading extends SavedLocationsState {
  const new();
}

final class SavedLocationsInitial extends SavedLocationsState {}
