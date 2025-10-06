
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future getOpenSessionId() async {
  String token = await getAccessTokenFromPref();
  String posTerminalId = await getPosTerminalIdFromPref();
  if(posTerminalId!='') {
    final uri = Uri.parse('$kOpenSessionIdUrl/$posTerminalId');
    var response = await http.get(
      uri,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    ).catchError((err) {
      // ignore: avoid_print
      print('100');
      // ignore: avoid_print
      print(err.response);
      return  [];
    });

    var p = json.decode(response.body);
    if (p['success'] == true) {
      return p;
    } else {
      return [];
    }
  }else {
    return  [];
  }
}

