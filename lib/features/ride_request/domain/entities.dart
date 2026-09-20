import 'package:maplibre_gl/maplibre_gl.dart';

class AddressEntity {
  final String status;
  final String formattedAddress;
  final String routeType;
  final String routeName;
  final String neighbourhood;
  final String city;
  final String state;
  final String place;
  final bool inTrafficZone;
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
}

class StateEntity {
  final LatLng location;
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
}

class SearchEntity {
  final String title;
  final String address;
  final String category;
  final String region;
  final String neighbourhood;
  final LatLng location;
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
}
