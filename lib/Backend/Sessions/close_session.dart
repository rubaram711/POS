import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future closeSession(String id,String note) async {
  // print(id);
  // print(note);
  String token = await getAccessTokenFromPref();

  final uri = Uri.parse('$kSessionsUrl/$id');
  var response = await http.post(
      uri,
      headers: {
        "Accept":"application/json",
        "Authorization": "Bearer $token"
      },
      body: {
        'note': note,
      }

  ) ;
  var p = json.decode(response.body);
  // print('close $p');
  return p;
}
