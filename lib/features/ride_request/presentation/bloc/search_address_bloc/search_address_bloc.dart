import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/get_searches.dart';
import 'package:flutter/foundation.dart';
import 'package:koolbar_demo/features/ride_request/domain/get_states_from_adress.dart';

part 'search_address_event.dart';
part 'search_address_state.dart';

@Injectable(scope: "RideRequest")
class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  final GetStatesFromAdress _getSearches;
  var _latestRequest = 0;

  SearchAddressBloc(this._getSearches) : super(SearchAddressInitial()) {
    on<RequestSearchAddress>(_requestSearchAddress);
  }

  Future<void> _requestSearchAddress(
    RequestSearchAddress event,
    Emitter<SearchAddressState> emit,
  ) async {
    final term = event.term.trim();
    emit(SearchAddressLoading());
    final res = await _getSearches(address: term,location: event.location,);
    if (res.status == ResourceStatus.Success) {
      emit(
        SearchAddressLoaded(searches: res.data ?? const []),
      );
    } else {
      emit(
        SearchAddressFailed(
          message: res.message ?? 'Unable to search locations.',
        ),
      );
    }
  }
}
