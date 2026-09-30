import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/common/resource.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/domain/usecase/save_new_location.dart';
import 'package:meta/meta.dart';

part 'new_saved_location_state.dart';

@Injectable(scope: "RideRequest")
class NewSavedLocationCubit extends Cubit<NewSaveLocationState> {
  final SaveNewLocation _saveNewLocation;
  NewSavedLocationCubit(this._saveNewLocation)
    : super(NewSaveLocationInitial());

  void saveNewLocation(NewSavedLocationEntity entity) async {
    emit(NewSaveLocationState.loading());
    final res = await _saveNewLocation(entity);
    switch (res.status) {
      case ResourceStatus.Success:
        emit(NewSaveLocationState.success(savedLocation: res.data!));
        break;
      case ResourceStatus.Failed:
        emit(NewSaveLocationState.failed(errorMsg: res.message!));
        break;
      default:
    }
  }
}
