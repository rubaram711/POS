import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';

Future selectRole(String selectedRole) async {
  // print('selectedRole $selectedRole');
  String token = await getAccessTokenFromPref();

  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token'
  };

  var jsonBody = {"selectedRole": selectedRole};
  final response = await http.post(Uri.parse(kSelectRoleUrl),
      headers: headers, body: jsonBody);

  Map body = json.decode(response.body);
  return body;

  // if (body['success'] == true) {
  //   print(body);
  //   return body;
  // } else {
  //   return [];
  //   // throw Exception(response.body);
  // }
}

// if I want to return  just roles array from body
// var e = body['data']['user']['roles'];
// print(e);

// print(response.statusCode);
// if (response['success'] == true) {
//
