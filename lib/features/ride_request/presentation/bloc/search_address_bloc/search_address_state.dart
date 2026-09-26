part of 'search_address_bloc.dart';

@immutable
sealed class SearchAddressState extends Equatable{
  final List<StateEntity>? searches;
  final String? errorMsg;
  const SearchAddressState({this.searches,this.errorMsg});
  @override
  // TODO: implement props
  List<Object?> get props => [searches,errorMsg,];
}

final class SearchAddressInitial extends SearchAddressState {}

final class SearchAddressLoading extends SearchAddressState {
  const SearchAddressLoading();
}

final class SearchAddressLoaded extends SearchAddressState {
  const SearchAddressLoaded({required List<StateEntity> searches}): super(searches: searches);
}

final class SearchAddressFailed extends SearchAddressState {
  const SearchAddressFailed({required String message}):super(errorMsg: message);

}
