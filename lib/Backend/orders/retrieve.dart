

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';

Future retrieve(
    String search,
    String sessionId,
    String cashTrayId,
    ) async {
  final uri = Uri.parse(kRetrieveUrl);
  String token = await getAccessTokenFromPref();
  var response = await http.post(uri, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token"
  }, body: {
    "search": search,
    "sessionId": sessionId,
    "cashTrayId": cashTrayId,
  });

  var p = json.decode(response.body);
  if(p['success']==true) {
    return p['data'];
  } else{
    return [];
  }//p['success']==true
}
