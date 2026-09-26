import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_permission_state.dart';

@LazySingleton()
class AppPermissionCubit extends Cubit<AppPermissionState> {
  AppPermissionCubit() : super(AppPermissionInitial());

  void askLocationPermission() async {
    final res = await Permission.location.request();
    if (res.isPermanentlyDenied) {
      openAppSettings().then((value) {});
    }
    if (res == PermissionStatus.granted) {
      emit(LocationPermissionGranted());
    } else {
      emit(LocationPermissionDenied());
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }
}
