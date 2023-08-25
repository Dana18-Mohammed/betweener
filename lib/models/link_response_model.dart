// To parse this JSON data, do
//
//     final linkResponseModel = linkResponseModelFromJson(jsonString);

import 'dart:convert';

LinkResponseModel linkResponseModelFromJson(String str) =>
    LinkResponseModel.fromJson(json.decode(str));

String linkResponseModelToJson(LinkResponseModel data) =>
    json.encode(data.toJson());

class LinkResponseModel {
  final List<Link>? links;

  LinkResponseModel({
    this.links,
  });

  LinkResponseModel copyWith({
    List<Link>? links,
  }) =>
      LinkResponseModel(
        links: links ?? this.links,
      );

  factory LinkResponseModel.fromJson(Map<String, dynamic> json) =>
      LinkResponseModel(
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
      };
}

class Link {
  final int? id;
  final String? title;
  final String? link;
  final String? username;
  final String? isActive;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  Link({
    this.id,
    this.title,
    this.link,
    this.username,
    this.isActive,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Link copyWith({
    int? id,
    String? title,
    String? link,
    String? username,
    String? isActive,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Link(
        id: id ?? this.id,
        title: title ?? this.title,
        link: link ?? this.link,
        username: username ?? this.username,
        isActive: isActive ?? this.isActive,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        id: json["id"],
        title: json["title"],
        link: json["link"],
        username: json["username"],
        isActive: json["isActive"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
        "username": username,
        "isActive": isActive,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
