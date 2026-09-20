part of 'search_address_bloc.dart';

@immutable
sealed class SearchAddressState {
  const SearchAddressState();
  factory SearchAddressState.initial() => SearchAddressInitial();
  factory SearchAddressState.loading() => SearchAddressLoading();
  factory SearchAddressState.loaded(List<SearchEntity> searches) =>
      SearchAddressLoaded(searches: searches);
  factory SearchAddressState.failed(String message) =>
      SearchAddressFailed(message: message);
}

final class SearchAddressLoading extends SearchAddressState {}

final class SearchAddressLoaded extends SearchAddressState {
  final List<SearchEntity> searches;
  new({required this.searches});
}

final class SearchAddressFailed extends SearchAddressState {
  final String message;
  new({required this.message});
}

final class SearchAddressInitial extends SearchAddressState {}
