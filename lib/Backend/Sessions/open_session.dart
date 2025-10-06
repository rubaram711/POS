

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future openSession(String note) async {
  String token = await getAccessTokenFromPref();
  String posTerminalId = await getPosTerminalIdFromPref();
  final uri = Uri.parse(kSessionsUrl);
  var response = await http.post(
      uri,
      headers: {
        "Accept":"application/json",
        "Authorization": "Bearer $token"
      },
      body: {
        'note': note,
        'posTerminalId':posTerminalId
      }

  ) ;
  var p = json.decode(response.body);
  return p;
}
