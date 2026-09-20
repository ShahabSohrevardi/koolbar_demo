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
  onOddEvenZone: json['on_odd_even_zone'] as bool,
  county: json['county'] as String,
  district: json['district'] as String,
);

Map<String, dynamic> _$AddressDTOToJson(AddressDTO instance) =>
    <String, dynamic>{
      'status': instance.status,
      'formatted_address': instance.formattedAddress,
      'route_type': instance.routeType,
      'route_name': instance.routeName,
      'neighbourhood': instance.neighbourhood,
      'city': instance.city,
      'state': instance.state,
      'place': instance.place,
      'in_traffic_zone': instance.inTrafficZone,
      'on_odd_even_zone': instance.onOddEvenZone,
      'county': instance.county,
      'district': instance.district,
    };

StateDTO _$StateDTOFromJson(Map<String, dynamic> json) => StateDTO(
  location: Map<String, String>.from(json['location'] as Map),
  province: json['province'] as String,
  city: json['city'] as String,
  neighbourhood: json['neighbourhood'] as String,
  unMatchedTerm: json['unMatchedTerm'] as String,
);

Map<String, dynamic> _$StateDTOToJson(StateDTO instance) => <String, dynamic>{
  'location': instance.location,
  'province': instance.province,
  'city': instance.city,
  'neighbourhood': instance.neighbourhood,
  'unMatchedTerm': instance.unMatchedTerm,
};

SearchDTO _$SearchDTOFromJson(Map<String, dynamic> json) => SearchDTO(
  title: json['title'] as String,
  address: json['address'] as String,
  category: json['category'] as String,
  region: json['region'] as String,
  neighbourhood: json['neighbourhood'] as String,
  location: Map<String, String>.from(json['location'] as Map),
  poiHash: json['poiHash'] as String,
);

Map<String, dynamic> _$SearchDTOToJson(SearchDTO instance) => <String, dynamic>{
  'title': instance.title,
  'address': instance.address,
  'category': instance.category,
  'region': instance.region,
  'neighbourhood': instance.neighbourhood,
  'location': instance.location,
  'poiHash': instance.poiHash,
};
