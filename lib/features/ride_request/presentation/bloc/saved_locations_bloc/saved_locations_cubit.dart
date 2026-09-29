import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/usecase/get_saved_locations.dart';
import 'package:meta/meta.dart';

part 'saved_locations_state.dart';

@Injectable(scope: "RideRequest")
class SavedLocationsCubit extends Cubit<SavedLocationsState> {
  final GetSavedLocations _getSavedLocations;
  SavedLocationsCubit(this._getSavedLocations) : super(SavedLocationsInitial());

  void savedLocationsUpdated(List<SavedLocationEntity> locations){
    var savedLocations =state.savedLocations;
    savedLocations?.addAll(locations);
    emit(state.copyWith(savedLocations: savedLocations));
  }

  void getSavedLocations() async {
    emit(SavedLocationsState.loading());
    final res=await _getSavedLocations();
    if(res.status==ResourceStatus.Success){
      emit(SavedLocationsState.success(res.data!));
    }
    else if(res.status==ResourceStatus.Failed) {
      emit(SavedLocationsState.failed(errorMsg: res.message!));
    }
  }
}
