

import 'dart:convert';

class Role {
  int? id;
  String? name;

  Role(
      { this.id,
         this.name,
      });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }


  static Map<String, dynamic> toMap(Role role) => {
    'id': role.id,
    'name': role.name,
  };

  static String encode(List<Role> roles) => json.encode(
    roles
        .map<Map<String, dynamic>>((role) => Role.toMap(role))
        .toList(),
  );

  static List<Role> decode(String roles) =>
      (json.decode(roles) as List<dynamic>)
          .map<Role>((role) => Role.fromJson(role))
          .toList();
}


