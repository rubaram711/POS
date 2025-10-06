import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../const/urls.dart';




Future getAllTransfers(String search) async {
  final uri = Uri.parse(kGetTransfersUrl).replace(queryParameters: {
    'search': search,
    'isPaginated':'0'
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
  // print('o $p');
  if(p['success']==true) {
    return p['data'];
  }else {
    return [];
  }
}

