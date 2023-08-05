// To parse this JSON data, do
//
//     final followee = followeeFromJson(jsonString);

import 'dart:convert';

Followee followeeFromJson(String str) => Followee.fromJson(json.decode(str));

String followeeToJson(Followee data) => json.encode(data.toJson());

class Followee {
  int followingCount;
  int followersCount;
  List<Following> following;
  List<dynamic> followers;

  Followee({
    required this.followingCount,
    required this.followersCount,
    required this.following,
    required this.followers,
  });

  factory Followee.fromJson(Map<String, dynamic> json) => Followee(
        followingCount: json["following_count"],
        followersCount: json["followers_count"],
        following: List<Following>.from(
            json["following"].map((x) => Following.fromJson(x))),
        followers: List<dynamic>.from(json["followers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "following_count": followingCount,
        "followers_count": followersCount,
        "following": List<dynamic>.from(following.map((x) => x.toJson())),
        "followers": List<dynamic>.from(followers.map((x) => x)),
      };
}

class Following {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isActive;
  dynamic country;
  dynamic ip;
  double? long;
  double? lat;

  Following({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.country,
    this.ip,
    this.long,
    this.lat,
  });

  factory Following.fromJson(Map<String, dynamic> json) => Following(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isActive: json["isActive"],
        country: json["country"],
        ip: json["ip"],
        long: json["long"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "isActive": isActive,
        "country": country,
        "ip": ip,
        "long": long,
        "lat": lat,
      };
}
