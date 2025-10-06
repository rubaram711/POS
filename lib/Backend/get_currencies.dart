import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future getCurrencies() async {
  final uri = Uri.parse(kGetCurrenciesUrl);
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
  }else {
    return [];
  }
}



// {success: true,
// data: [{id: 1, company_id: 1,
// name: USD,
// symbol: $,
// active: 1,
// created_at: 2024-02-21T03:18:47.000000Z,
// updated_at: 2024-02-21T03:18:47.000000Z,
// deleted_at: null}],
// message: Currencies fetched successfully}


