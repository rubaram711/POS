import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';

Future openCashTray(
    String sessionId,
    String usdOpeningAmount,
    String otherCurrencyOpeningAmount,
    ) async {
  ProductController productController=Get.find();
  final uri = Uri.parse('$kCashTrayUrl/$sessionId');
  String token = await getAccessTokenFromPref();
  String posCurrencyId = await getCompanyPosCurrencyIdFromPref();
  String primaryCurrencyId = await getCompanyPrimaryCurrencyIdFromPref();
  // print('object 4 $sessionId');
  // print('object 4 $usdOpeningAmount');
  // print('object 4 $otherCurrencyOpeningAmount');
  var response = await http.post(uri, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token"
  }, body: {
    // "sessionId": sessionId,
    // "usdOpeningAmount": usdOpeningAmount,
    // "otherCurrencyOpeningAmount": otherCurrencyOpeningAmount,
    "sessionId": sessionId,
    "primaryCurrencyOpeningAmount": usdOpeningAmount,
    "posCurrencyOpeningAmount":primaryCurrencyId==posCurrencyId?usdOpeningAmount: otherCurrencyOpeningAmount,
    "primaryCurrencyId": primaryCurrencyId,
    "posCurrencyId": posCurrencyId,
    "primaryCurrencyRate": '1',
    "posCurrencyRate": productController.posCurrencyLatestRate,
  });

  var p = json.decode(response.body);
  // print('objectgg $p');
  return p; //p['success']==true
}
