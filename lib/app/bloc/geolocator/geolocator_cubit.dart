import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocator_state.dart';

@LazySingleton()
class GeolocatorCubit extends Cubit<GeolocatorState> {
  GeolocatorCubit() : super(GeolocatorInitial());

  void getCurrentLocation() async {
    emit(GeolocatorLoading());
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      emit(GeolocatorError(errorMsg: "Permission denied"));
      return;
    }
    final res = await Geolocator.getCurrentPosition();
    emit(GeolocatorSuccess(latitude: res.latitude, longitude: res.longitude));
  }
}
