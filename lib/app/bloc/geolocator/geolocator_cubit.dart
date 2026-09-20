import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocator_state.dart';

@LazySingleton()
class GeolocatorCubit extends Cubit<GeolocatorState> {
  GeolocatorCubit() : super(GeolocatorInitial());

  void getCurrentLocation() async {
    emit(GeolocatorLoading());
    final permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      emit(GeolocatorError(message: "Permission denied"));
      return;
    }
    final res = await Geolocator.getCurrentPosition();
    emit(GeolocatorSuccess(latitude: res.latitude, longitude: res.longitude));
  }
}


