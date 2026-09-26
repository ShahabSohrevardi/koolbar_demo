part of 'search_address_bloc.dart';

@immutable
sealed class SearchAddressEvent {}

enum SearchAddressField { pickup, destination }

class RequestSearchAddress extends SearchAddressEvent {
  RequestSearchAddress({
    required this.term,
    required this.location,
  });

  final String term;
  final Map<String, double> location;
}


