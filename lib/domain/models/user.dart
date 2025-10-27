import 'dart:convert';

/// Domain model representing a user fetched from RandomUser API.
class User {
  const User({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final DateInfo dob;
  final DateInfo registered;
  final String phone;
  final String cell;
  final Id id;
  final Picture picture;
  final String nat;

  String get uuid => login.uuid;

  /// Factory that parses the API JSON structure.
  factory User.fromApiJson(Map<String, dynamic> json) {
    return User(
      gender: json['gender'] as String? ?? '',
      name: Name.fromJson(json['name'] as Map<String, dynamic>? ?? const {}),
      location:
          Location.fromJson(json['location'] as Map<String, dynamic>? ?? const {}),
      email: json['email'] as String? ?? '',
      login: Login.fromJson(json['login'] as Map<String, dynamic>? ?? const {}),
      dob: DateInfo.fromJson(json['dob'] as Map<String, dynamic>? ?? const {}),
      registered: DateInfo.fromJson(
        json['registered'] as Map<String, dynamic>? ?? const {},
      ),
      phone: json['phone'] as String? ?? '',
      cell: json['cell'] as String? ?? '',
      id: Id.fromJson(json['id'] as Map<String, dynamic>? ?? const {}),
      picture:
          Picture.fromJson(json['picture'] as Map<String, dynamic>? ?? const {}),
      nat: json['nat'] as String? ?? '',
    );
  }

  /// Converts to a JSON-serialisable map for persistence.
  Map<String, dynamic> toPersistenceMap() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': dob.toJson(),
      'registered': registered.toJson(),
      'phone': phone,
      'cell': cell,
      'id': id.toJson(),
      'picture': picture.toJson(),
      'nat': nat,
    };
  }

  /// Creates [User] from persisted map structure.
  factory User.fromPersistenceMap(Map<String, dynamic> map) {
    return User(
      gender: map['gender'] as String? ?? '',
      name: Name.fromJson(map['name'] as Map<String, dynamic>? ?? const {}),
      location: Location.fromJson(
        map['location'] as Map<String, dynamic>? ?? const {},
      ),
      email: map['email'] as String? ?? '',
      login: Login.fromJson(map['login'] as Map<String, dynamic>? ?? const {}),
      dob: DateInfo.fromJson(map['dob'] as Map<String, dynamic>? ?? const {}),
      registered: DateInfo.fromJson(
        map['registered'] as Map<String, dynamic>? ?? const {},
      ),
      phone: map['phone'] as String? ?? '',
      cell: map['cell'] as String? ?? '',
      id: Id.fromJson(map['id'] as Map<String, dynamic>? ?? const {}),
      picture:
          Picture.fromJson(map['picture'] as Map<String, dynamic>? ?? const {}),
      nat: map['nat'] as String? ?? '',
    );
  }

  /// Serialises to JSON string for convenience when storing.
  String toJsonString() => jsonEncode(toPersistenceMap());

  /// Deserialises from JSON string.
  factory User.fromJsonString(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromPersistenceMap(map);
  }
}

class Name {
  const Name({
    required this.title,
    required this.first,
    required this.last,
  });

  final String title;
  final String first;
  final String last;

  String get fullName => [title, first, last]
      .where((segment) => segment.isNotEmpty)
      .join(' ')
      .trim();

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'] as String? ?? '',
      first: json['first'] as String? ?? '',
      last: json['last'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }
}

class Location {
  const Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: Street.fromJson(json['street'] as Map<String, dynamic>? ?? const {}),
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postcode: _asString(json['postcode']),
      coordinates: Coordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>? ?? const {},
      ),
      timezone: Timezone.fromJson(
        json['timezone'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toJson(),
      'timezone': timezone.toJson(),
    };
  }
}

class Street {
  const Street({
    required this.number,
    required this.name,
  });

  final int number;
  final String name;

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(
      number: (json['number'] is int)
          ? json['number'] as int
          : int.tryParse('${json['number']}') ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
    };
  }
}

class Coordinates {
  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  final String latitude;
  final String longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Timezone {
  const Timezone({
    required this.offset,
    required this.description,
  });

  final String offset;
  final String description;

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      offset: json['offset'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'description': description,
    };
  }
}

class Login {
  const Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      uuid: json['uuid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      salt: json['salt'] as String? ?? '',
      md5: json['md5'] as String? ?? '',
      sha1: json['sha1'] as String? ?? '',
      sha256: json['sha256'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}

class DateInfo {
  const DateInfo({
    required this.date,
    required this.age,
  });

  final DateTime date;
  final int age;

  factory DateInfo.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] as String? ?? '';
    return DateInfo(
      date: rawDate.isEmpty ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(rawDate),
      age: (json['age'] is int)
          ? json['age'] as int
          : int.tryParse('${json['age']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'age': age,
    };
  }
}

class Id {
  const Id({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      name: json['name'] as String? ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class Picture {
  const Picture({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });

  final String large;
  final String medium;
  final String thumbnail;

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }

  if (value is String) {
    return value;
  }

  return value.toString();
}
