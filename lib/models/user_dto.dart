import 'dart:convert';

class UserDto {
    int id;
    String username;
    String email;
    List<Role> roles;
    String accessToken;
    String refreshToken;
    String type;
    DateTime currentDateTime;
    bool firstLogin;

    UserDto({
        required this.id,
        required this.username,
        required this.email,
        required this.roles,
        required this.accessToken,
        required this.refreshToken,
        required this.type,
        required this.currentDateTime,
        required this.firstLogin,
    });

    factory UserDto.fromRawJson(String str) => UserDto.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        type: json["type"],
        currentDateTime: DateTime.parse(json["currentDateTime"]),
        firstLogin: json["firstLogin"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "type": type,
        "currentDateTime": currentDateTime.toIso8601String(),
        "firstLogin": firstLogin
    };
}

class Role {
    dynamic id;
    String roleName;

    Role({
        required this.id,
        required this.roleName,
    });

    factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        roleName: json["roleName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "roleName": roleName,
    };
}