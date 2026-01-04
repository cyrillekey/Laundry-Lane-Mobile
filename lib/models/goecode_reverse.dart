class GeocodeReverse {
  String? type;
  Properties? properties;
  Geometry? geometry;
  List<double>? bbox;

  GeocodeReverse({this.type, this.properties, this.geometry, this.bbox});

  factory GeocodeReverse.fromJson(Map<String, dynamic> json) => GeocodeReverse(
    type: json["type"],
    properties:
        json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
    geometry:
        json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    bbox:
        json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties?.toJson(),
    "geometry": geometry?.toJson(),
    "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
  };
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates:
        json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates":
        coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class Properties {
  Datasource? datasource;
  String? name;
  String? country;
  String? countryCode;
  String? state;
  String? county;
  String? city;
  String? postcode;
  String? street;
  String? iso31662;
  double? lon;
  double? lat;
  String? stateCode;
  String? countyCode;
  double? distance;
  String? resultType;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  String? category;
  Timezone? timezone;
  String? plusCode;
  Rank? rank;
  String? placeId;

  Properties({
    this.datasource,
    this.name,
    this.country,
    this.countryCode,
    this.state,
    this.county,
    this.city,
    this.postcode,
    this.street,
    this.iso31662,
    this.lon,
    this.lat,
    this.stateCode,
    this.countyCode,
    this.distance,
    this.resultType,
    this.formatted,
    this.addressLine1,
    this.addressLine2,
    this.category,
    this.timezone,
    this.plusCode,
    this.rank,
    this.placeId,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    datasource:
        json["datasource"] == null
            ? null
            : Datasource.fromJson(json["datasource"]),
    name: json["name"],
    country: json["country"],
    countryCode: json["country_code"],
    state: json["state"],
    county: json["county"],
    city: json["city"],
    postcode: json["postcode"],
    street: json["street"],
    iso31662: json["iso3166_2"],
    lon: json["lon"]?.toDouble(),
    lat: json["lat"]?.toDouble(),
    stateCode: json["state_code"],
    countyCode: json["county_code"],
    distance: json["distance"]?.toDouble(),
    resultType: json["result_type"],
    formatted: json["formatted"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    category: json["category"],
    timezone:
        json["timezone"] == null ? null : Timezone.fromJson(json["timezone"]),
    plusCode: json["plus_code"],
    rank: json["rank"] == null ? null : Rank.fromJson(json["rank"]),
    placeId: json["place_id"],
  );

  Map<String, dynamic> toJson() => {
    "datasource": datasource?.toJson(),
    "name": name,
    "country": country,
    "country_code": countryCode,
    "state": state,
    "county": county,
    "city": city,
    "postcode": postcode,
    "street": street,
    "iso3166_2": iso31662,
    "lon": lon,
    "lat": lat,
    "state_code": stateCode,
    "county_code": countyCode,
    "distance": distance,
    "result_type": resultType,
    "formatted": formatted,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "category": category,
    "timezone": timezone?.toJson(),
    "plus_code": plusCode,
    "rank": rank?.toJson(),
    "place_id": placeId,
  };
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Datasource({this.sourcename, this.attribution, this.license, this.url});

  factory Datasource.fromJson(Map<String, dynamic> json) => Datasource(
    sourcename: json["sourcename"],
    attribution: json["attribution"],
    license: json["license"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "sourcename": sourcename,
    "attribution": attribution,
    "license": license,
    "url": url,
  };
}

class Rank {
  double? importance;
  double? popularity;

  Rank({this.importance, this.popularity});

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
    importance: json["importance"]?.toDouble(),
    popularity: json["popularity"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "importance": importance,
    "popularity": popularity,
  };
}

class Timezone {
  String? name;
  String? offsetStd;
  int? offsetStdSeconds;
  String? offsetDst;
  int? offsetDstSeconds;
  String? abbreviationStd;
  String? abbreviationDst;

  Timezone({
    this.name,
    this.offsetStd,
    this.offsetStdSeconds,
    this.offsetDst,
    this.offsetDstSeconds,
    this.abbreviationStd,
    this.abbreviationDst,
  });

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
    name: json["name"],
    offsetStd: json["offset_STD"],
    offsetStdSeconds: json["offset_STD_seconds"],
    offsetDst: json["offset_DST"],
    offsetDstSeconds: json["offset_DST_seconds"],
    abbreviationStd: json["abbreviation_STD"],
    abbreviationDst: json["abbreviation_DST"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "offset_STD": offsetStd,
    "offset_STD_seconds": offsetStdSeconds,
    "offset_DST": offsetDst,
    "offset_DST_seconds": offsetDstSeconds,
    "abbreviation_STD": abbreviationStd,
    "abbreviation_DST": abbreviationDst,
  };
}

class Query {
  double? lat;
  double? lon;
  String? plusCode;

  Query({this.lat, this.lon, this.plusCode});

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    plusCode: json["plus_code"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lon": lon,
    "plus_code": plusCode,
  };
}
