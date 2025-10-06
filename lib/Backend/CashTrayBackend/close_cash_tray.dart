import 'package:http/http.dart' as http;
import 'package:pos_project/Locale_Memory/save_company_info_locally.dart';
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future closeCashTray(String id,String usdOpeningBalance , String otherCurrencyOpeningBalance , String nonCashUsdAmount ,String nonCashOtherCurrencyAmount) async {
  String token = await getAccessTokenFromPref();
  String posCurrencyId = await getCompanyPosCurrencyIdFromPref();
  String primaryCurrencyId = await getCompanyPrimaryCurrencyIdFromPref();

  // print('iddd $id');
  // print('iddd $usdOpeningBalance');
  // print('iddd $otherCurrencyOpeningBalance');
  // print('iddd $nonCashUsdAmount');
  // print('iddd $nonCashOtherCurrencyAmount');

  final uri = Uri.parse('$kCloseCashTrayUrl/$id');
  var response = await http.post(
      uri,
      headers: {
        "Accept":"application/json",
        "Authorization": "Bearer $token"
      },
      body: {
        // 'usdClosingAmount': usdOpeningBalance,
        // 'otherCurrencyClosingAmount': otherCurrencyOpeningBalance,
        // 'nonCashUsdAmount': nonCashUsdAmount,
        // 'nonCashOtherCurrencyAmount': nonCashOtherCurrencyAmount,
        'primaryCurrencyClosingAmount': usdOpeningBalance,
        'posCurrencyClosingAmount':primaryCurrencyId==posCurrencyId?usdOpeningBalance: otherCurrencyOpeningBalance,
        'nonCashPrimaryCurrencyAmount': nonCashUsdAmount,
        'nonCashPosCurrencyAmount':primaryCurrencyId==posCurrencyId?nonCashUsdAmount: nonCashOtherCurrencyAmount,
        'primaryCurrencyId': primaryCurrencyId,
        'posCurrencyId': posCurrencyId,
      }

  ) ;
  var p = json.decode(response.body);
  // print('close $p');
  return p;
}
