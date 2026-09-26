// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDTO _$AddressDTOFromJson(Map<String, dynamic> json) => AddressDTO(
  status: json['status'] as String,
  formattedAddress: json['formatted_address'] as String,
  routeType: json['route_type'] as String,
  routeName: json['route_name'] as String,
  neighbourhood: json['neighbourhood'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  place: json['place'] as String,
  inTrafficZone: json['in_traffic_zone'] as bool,
  onOddEvenZone: json['in_odd_even_zone'] as bool,
  county: json['county'] as String,
  district: json['district'] as String,
);

StateDTO _$StateDTOFromJson(Map<String, dynamic> json) => StateDTO(
  location: json['location'] as Map<String, dynamic>,
  province: json['province'] as String,
  city: json['city'] as String?,
  unMatchedTerm: json['unMatchedTerm'] as String,
);

SearchDTO _$SearchDTOFromJson(Map<String, dynamic> json) => SearchDTO(
  title: json['title'] as String,
  address: json['address'] as String,
  category: json['category'] as String,
  region: json['region'] as String,
  neighbourhood: json['neighbourhood'] as String,
  location: json['location'] as Map<String, dynamic>,
  poiHash: json['poiHash'] as String,
);
