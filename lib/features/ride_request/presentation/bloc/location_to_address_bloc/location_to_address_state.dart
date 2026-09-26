part of 'location_to_address_cubit.dart';

@immutable
sealed class LocationToAddressState extends Equatable {
  final AddressEntity? entity;
  final String? errorMsg;

  const new({this.entity, this.errorMsg});

  factory LocationToAddressState.initial() => LocationToAddressInitial();

  factory LocationToAddressState.loading() => LocationToAddressLoading();

  factory LocationToAddressState.loaded({required AddressEntity entity}) =>
      LocationToAddressLoaded(entity: entity);

  factory LocationToAddressState.failed({required String errorMsg}) =>
      LocationToAddressFailed(errorMsg: errorMsg);

  @override
  // TODO: implement props
  List<Object?> get props => [entity, errorMsg];
}

final class LocationToAddressInitial extends LocationToAddressState {}

final class LocationToAddressLoading extends LocationToAddressState {}

final class LocationToAddressLoaded extends LocationToAddressState {
  const LocationToAddressLoaded({required AddressEntity entity})
    : super(entity: entity);
}

final class LocationToAddressFailed extends LocationToAddressState {
  const LocationToAddressFailed({required String errorMsg})
    : super(errorMsg: errorMsg);
}
