import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/core/network/client_helper.dart';
import 'package:koolbar_demo/features/ride_request/data/dto.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';

@LazySingleton(scope: "RideRequest")
class AddressCloudDataSource {
  final ClientHelper _clientHelper;

  new(@Named("MapClient") this._clientHelper);

  Future<AddressDTO> getAddressByState(double lat, double long) async {
    final res = await _clientHelper.get("/v5/reverse?lat=$lat&lng=$long");
    if (res.statusCode != 200) {
      throw res.statusMessage!;
    }
    return AddressDTO.fromJson(res.data);
  }

  Future<List<StateDTO>> getStatesByAddress({
    required String address,
    String? province,
    String? city,
    Map<String, String>? location,
  }) async {
    final res = await _clientHelper.get(
      "/v5/reverse?address=$address&province=$province&city=$city",
    );
    if (res.statusCode != 200) {
      throw res.statusMessage!;
    }
    return (res.data["items"] as List<dynamic>)
        .map((e) => StateDTO.fromJson(e))
        .toList();
  }

  Future<List<SearchDTO>> getSearches(
    String term,
    Map<String, double> location,
  ) async {
    final res = await _clientHelper.get("v3/search?term=$term", {
      "center": location,
    });
    return (res.data["items"] as List<dynamic>)
        .map((e) => SearchDTO.fromJson(e))
        .toList();
  }
}
