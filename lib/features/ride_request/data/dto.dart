import 'package:json_annotation/json_annotation.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

part 'dto.g.dart';

@JsonSerializable()
class AddressDTO {
  final String status;
  @JsonKey(name: "formatted_address")
  final String formattedAddress;
  @JsonKey(name: "route_type")
  final String routeType;
  @JsonKey(name: "route_name")
  final String routeName;
  final String neighbourhood;
  final String city;
  final String state;
  final String place;
  @JsonKey(name: "in_traffic_zone")
  final bool inTrafficZone;
  @JsonKey(name: "on_odd_even_zone")
  final bool onOddEvenZone;
  final String county;
  final String district;

  new({
    required this.status,
    required this.formattedAddress,
    required this.routeType,
    required this.routeName,
    required this.neighbourhood,
    required this.city,
    required this.state,
    required this.place,
    required this.inTrafficZone,
    required this.onOddEvenZone,
    required this.county,
    required this.district,
  });

  factory AddressDTO.fromJson(Map<String, dynamic> json) =>
      _$AddressDTOFromJson(json);

  AddressEntity toEntity() => AddressEntity(
    status: status,
    formattedAddress: formattedAddress,
    routeType: routeType,
    routeName: routeName,
    neighbourhood: neighbourhood,
    city: city,
    state: state,
    place: place,
    inTrafficZone: inTrafficZone,
    onOddEvenZone: onOddEvenZone,
    county: county,
    district: district,
  );
}

@JsonSerializable()
class StateDTO {
  final Map<String, String> location;
  final String province;
  final String city;
  final String neighbourhood;
  final String unMatchedTerm;

  new({
    required this.location,
    required this.province,
    required this.city,
    required this.neighbourhood,
    required this.unMatchedTerm,
  });

  factory StateDTO.fromJson(Map<String, dynamic> json) =>
      _$StateDTOFromJson(json);

  StateEntity toEntity() => StateEntity(
    location: LatLng(
      location["latitude"] as double,
      location["longitude"] as double,
    ),
    province: province,
    city: city,
    neighbourhood: neighbourhood,
    unMatchedTerm: unMatchedTerm,
  );
}

@JsonSerializable()
class SearchDTO {
  final String title;
  final String address;
  final String category;
  final String region;
  final String neighbourhood;
  final Map<String, String> location;
  final String poiHash;

  new({
    required this.title,
    required this.address,
    required this.category,
    required this.region,
    required this.neighbourhood,
    required this.location,
    required this.poiHash,
  });

  factory SearchDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchDTOFromJson(json);

  SearchEntity toEntity() => SearchEntity(
    title: title,
    address: address,
    category: category,
    region: region,
    neighbourhood: neighbourhood,
    location: LatLng(
      location["latitude"] as double,
      location["longitude"] as double,
    ),
    poiHash: poiHash,
  );
}
