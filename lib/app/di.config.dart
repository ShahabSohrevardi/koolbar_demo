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
import 'package:koolbar_demo/features/ride_request/data/address_cloud_data_source.dart'
    as _i493;
import 'package:koolbar_demo/features/ride_request/data/address_data_repository.dart'
    as _i927;
import 'package:koolbar_demo/features/ride_request/domain/address_repository.dart'
    as _i1065;
import 'package:koolbar_demo/features/ride_request/domain/get_addresses_from_state.dart'
    as _i625;
import 'package:koolbar_demo/features/ride_request/domain/get_searches.dart'
    as _i353;
import 'package:koolbar_demo/features/ride_request/domain/get_states_from_adress.dart'
    as _i412;
import 'package:koolbar_demo/features/ride_request/presentation/bloc/location_to_address_bloc/location_to_address_cubit.dart'
    as _i1;
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
        gh.lazySingleton<_i493.AddressCloudDataSource>(
          () => _i493.AddressCloudDataSource(
            gh<_i220.ClientHelper>(instanceName: 'MapClient'),
          ),
        );
        gh.lazySingleton<_i1065.AddressRepository>(
          () => _i927.AddressDataRepository(gh<_i493.AddressCloudDataSource>()),
        );
        gh.lazySingleton<_i625.GetAddressesFromState>(
          () => _i625.GetAddressesFromState(
            repository: gh<_i1065.AddressRepository>(),
          ),
        );
        gh.lazySingleton<_i412.GetStatesFromAdress>(
          () => _i412.GetStatesFromAdress(
            repository: gh<_i1065.AddressRepository>(),
          ),
        );
        gh.lazySingleton<_i353.GetSearches>(
          () => _i353.GetSearches(gh<_i1065.AddressRepository>()),
        );
        gh.factory<_i1.LocationToAddressCubit>(
          () => _i1.LocationToAddressCubit(gh<_i625.GetAddressesFromState>()),
        );
        gh.factory<_i402.SearchAddressBloc>(
          () => _i402.SearchAddressBloc(gh<_i412.GetStatesFromAdress>()),
        );
      },
    );
  }
}

class _$AppModule extends _i925.AppModule {}
