

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';

Future  checkIfCanSellZero() async {
  final uri = Uri.parse(kCheckIfCanSellZeroUrl);
  String token = await getAccessTokenFromPref();
  String roleName=await getRoleNameFromPref();
  var response = await http.post(uri, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token"
  }, body: {
    "roleName":roleName
  });

  var p = json.decode(response.body);
  return p;
}
