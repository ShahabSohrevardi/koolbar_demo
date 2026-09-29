// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:koolbar_demo/app/bloc/geolocator/geolocator_cubit.dart'
    as _i330;
import 'package:koolbar_demo/app/bloc/permission/app_permission_cubit.dart'
    as _i284;
import 'package:koolbar_demo/app/di.dart' as _i925;
import 'package:koolbar_demo/core/network/client_helper.dart' as _i220;
import 'package:koolbar_demo/features/ride_request/api/navigation.dart' as _i70;
import 'package:koolbar_demo/features/ride_request/data/address_cloud_data_source.dart'
    as _i493;
import 'package:koolbar_demo/features/ride_request/data/address_data_repository.dart'
    as _i927;
import 'package:koolbar_demo/features/ride_request/data/dao.dart' as _i984;
import 'package:koolbar_demo/features/ride_request/data/saved_location_data_repository.dart'
    as _i1065;
import 'package:koolbar_demo/features/ride_request/data/saved_location_local_data_source.dart'
    as _i552;
import 'package:koolbar_demo/features/ride_request/domain/address_repository.dart'
    as _i1066;
import 'package:koolbar_demo/features/ride_request/domain/saved_location_repository.dart'
    as _i117;
import 'package:koolbar_demo/features/ride_request/domain/usecase/get_addresses_from_state.dart'
    as _i525;
import 'package:koolbar_demo/features/ride_request/domain/usecase/get_saved_locations.dart'
    as _i618;
import 'package:koolbar_demo/features/ride_request/domain/usecase/get_searches.dart'
    as _i857;
import 'package:koolbar_demo/features/ride_request/domain/usecase/get_states_from_adress.dart'
    as _i71;
import 'package:koolbar_demo/features/ride_request/domain/usecase/save_new_location.dart'
    as _i849;
import 'package:koolbar_demo/features/ride_request/navigation/navigation_impl.dart'
    as _i1060;
import 'package:koolbar_demo/features/ride_request/presentation/bloc/location_to_address_bloc/location_to_address_cubit.dart'
    as _i1;
import 'package:koolbar_demo/features/ride_request/presentation/bloc/save_location_bloc/new_saved_location_cubit.dart'
    as _i469;
import 'package:koolbar_demo/features/ride_request/presentation/bloc/saved_locations_bloc/saved_locations_cubit.dart'
    as _i950;
import 'package:koolbar_demo/features/ride_request/presentation/bloc/search_address_bloc/search_address_bloc.dart'
    as _i402;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.provideSharedReferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i330.GeolocatorCubit>(() => _i330.GeolocatorCubit());
    gh.lazySingleton<_i284.AppPermissionCubit>(
      () => _i284.AppPermissionCubit(),
    );
    gh.singleton<_i220.ClientHelper>(
      () => appModule.provideBaseClientHelper(gh<_i460.SharedPreferences>()),
      instanceName: 'BaseClient',
    );
    gh.singleton<_i220.ClientHelper>(
      () => appModule.provideMapClientHelper(),
      instanceName: 'MapClient',
    );
    return this;
  }

  // initializes the registration of RideRequest-scope dependencies inside of GetIt
  _i174.GetIt initRideRequestScope({_i174.ScopeDisposeFunc? dispose}) {
    return _i526.GetItHelper(this).initScope(
      'RideRequest',
      dispose: dispose,
      init: (_i526.GetItHelper gh) {
        gh.lazySingleton<_i984.SavedLocationDao>(
          () => _i984.SavedLocationDao(),
        );
        gh.lazySingleton<_i552.SavedLocationLocalDataSource>(
          () => _i552.SavedLocationLocalDataSource(
            dao: gh<_i984.SavedLocationDao>(),
          ),
        );
        gh.lazySingleton<_i493.AddressCloudDataSource>(
          () => _i493.AddressCloudDataSource(
            gh<_i220.ClientHelper>(instanceName: 'MapClient'),
          ),
        );
        gh.lazySingleton<_i117.SavedLocationRepository>(
          () => _i1065.SavedLocationDataRepository(
            gh<_i552.SavedLocationLocalDataSource>(),
          ),
        );
        gh.lazySingleton<_i1066.AddressRepository>(
          () => _i927.AddressDataRepository(gh<_i493.AddressCloudDataSource>()),
        );
        gh.lazySingleton<_i525.GetAddressesFromState>(
          () => _i525.GetAddressesFromState(
            repository: gh<_i1066.AddressRepository>(),
          ),
        );
        gh.lazySingleton<_i71.GetStatesFromAdress>(
          () => _i71.GetStatesFromAdress(
            repository: gh<_i1066.AddressRepository>(),
          ),
        );
        gh.lazySingleton<_i857.GetSearches>(
          () => _i857.GetSearches(gh<_i1066.AddressRepository>()),
        );
        gh.lazySingleton<_i618.GetSavedLocations>(
          () => _i618.GetSavedLocations(gh<_i117.SavedLocationRepository>()),
        );
        gh.lazySingleton<_i849.SaveNewLocation>(
          () => _i849.SaveNewLocation(gh<_i117.SavedLocationRepository>()),
        );
        gh.factory<_i469.NewSavedLocationCubit>(
          () => _i469.NewSavedLocationCubit(gh<_i849.SaveNewLocation>()),
        );
        gh.factory<_i402.SearchAddressBloc>(
          () => _i402.SearchAddressBloc(gh<_i71.GetStatesFromAdress>()),
        );
        gh.factory<_i1.LocationToAddressCubit>(
          () => _i1.LocationToAddressCubit(gh<_i525.GetAddressesFromState>()),
        );
        gh.factory<_i950.SavedLocationsCubit>(
          () => _i950.SavedLocationsCubit(gh<_i618.GetSavedLocations>()),
        );
      },
    );
  }

  // initializes the registration of RideRequestApi-scope dependencies inside of GetIt
  _i174.GetIt initRideRequestApiScope({_i174.ScopeDisposeFunc? dispose}) {
    return _i526.GetItHelper(this).initScope(
      'RideRequestApi',
      dispose: dispose,
      init: (_i526.GetItHelper gh) {
        gh.lazySingleton<_i70.RideRequestNavigation>(
          () => _i1060.RideRequestNavigationImpl(),
        );
      },
    );
  }
}

class _$AppModule extends _i925.AppModule {}
