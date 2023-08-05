import 'dart:convert';

Links linksFromJson(String str) => Links.fromJson(json.decode(str));

String linksToJson(Links data) => json.encode(data.toJson());

class Links {
  int? id;
  String? title;
  String? link;
  String? username;
  int? isActive;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Links({
    this.id,
    this.title,
    this.link,
    this.username,
    this.isActive,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
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
