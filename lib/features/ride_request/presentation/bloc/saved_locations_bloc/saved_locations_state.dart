part of 'saved_locations_cubit.dart';

@immutable
class SavedLocationsState extends Equatable {
  final List<SavedLocationEntity> savedLocations;
  final String? errorMsg;
  final bool isLoading;

  const SavedLocationsState({
    this.savedLocations = const [],
    this.errorMsg,
    this.isLoading = false,
  });

  factory SavedLocationsState.success(
    List<SavedLocationEntity> savedLocations,
  ) => SavedLocationsState(savedLocations: savedLocations);

  factory SavedLocationsState.failed({required String errorMsg}) =>
      SavedLocationsState(errorMsg: errorMsg);

  factory SavedLocationsState.loading() => SavedLocationsState(isLoading: true);

  SavedLocationsState copyWith({
    List<SavedLocationEntity>? savedLocations,
    String? errorMsg,
  }) => SavedLocationsState(
    savedLocations: savedLocations ?? this.savedLocations,
    errorMsg: this.errorMsg ?? errorMsg,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [savedLocations, errorMsg, isLoading];
}

final class SavedLocationsInitial extends SavedLocationsState {}
