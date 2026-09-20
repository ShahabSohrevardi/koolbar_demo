part of 'search_address_bloc.dart';

@immutable
sealed class SearchAddressEvent {}

class RequestSearchAddress extends SearchAddressEvent {
  final String term;
  final Map<String, double> location;
  new({required this.term, required this.location});
}
