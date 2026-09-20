import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/network/client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'di.config.dart';

final getIt=GetIt.instance;
@InjectableInit()
Future<void> initConfiguration()=>getIt.init();

@module
@module
abstract class AppModule {
  @preResolve
  @singleton
  Future<SharedPreferences> provideSharedReferences() =>
      SharedPreferences.getInstance();

  @singleton
  @Named("BaseClient")
  ClientHelper provideBaseClientHelper(SharedPreferences sharedPreferences) {
    final token=sharedPreferences.getString("token");
    return ClientHelper.connect("http://127.0.0.1:8000",{"Authorization":"Bearer $token"});
  }

  @singleton
  @Named("MapClient")
  ClientHelper provideMapClientHelper(){
    final token = dotenv.get("NESHAN_API_TOKEN");
    final base_url= dotenv.get("NESHAN_BASE_URL");
    return ClientHelper.connect(base_url,{"API_KEY":token});
  }
}