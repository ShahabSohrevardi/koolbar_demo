import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/get_searches.dart';
import 'package:meta/meta.dart';

part 'search_address_event.dart';
part 'search_address_state.dart';

@Injectable(scope: "RideRequest")
class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  final GetSearches _getSearches;
  SearchAddressBloc(this._getSearches) : super(SearchAddressInitial()) {
    on<RequestSearchAddress>(_requestSearchAddress);
  }

  void _requestSearchAddress(RequestSearchAddress event,Emitter<SearchAddressState> emit) async {
    emit(SearchAddressState.loading());
    final res=await _getSearches(event.term, event.location);
    if(res.status==ResourceStatus.Success){
      emit(SearchAddressState.loaded(res.data!));
    }else{
      emit(SearchAddressState.failed(res.message!));
    }
  }
}
