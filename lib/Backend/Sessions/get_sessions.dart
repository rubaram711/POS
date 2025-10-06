import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future getAllSessions(String search) async {
  String posTerminalId = await getPosTerminalIdFromPref();

  final uri = Uri.parse(kSessionsUrl).replace(queryParameters: {
    'search': search,
    'posTerminalId': posTerminalId,
    'isPaginated':'0',
  });
  String token = await getAccessTokenFromPref();
  var response = await http.get(
    uri,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  var p = json.decode(response.body);
  if(response.statusCode==200) {
    return p['data'];
  }else{
    return [];
  }
}

