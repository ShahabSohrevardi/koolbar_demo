import 'package:equatable/equatable.dart';
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

class StateEntity extends Equatable {
  final LatLng location;
  final String province;
  final String? city;

  // final String neighbourhood;
  final String unMatchedTerm;

  new({
    required this.location,
    required this.province,
    required this.city,
    // required this.neighbourhood,
    required this.unMatchedTerm,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [location, province, city, unMatchedTerm];
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


class NewSavedLocationEntity {
  final String name;
  final double latitude;
  final double longitude;
  final int? iconCodePoint;

  new({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.iconCodePoint,
  });
}

class SavedLocationEntity {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int? iconCodePoint;

  new({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.iconCodePoint,
  });
}
