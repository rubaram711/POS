import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';


Future storeQuotation(
    String manualReference, String clientId,String validity,String paymentTerm,String priceList,
    String currency, String termsAndConditions,String salespersonId,String commissionMethodId,String cashingMethodId,
    String commissionRate, String commissionTotal,String totalBeforeVat,String specialDiscountPercentage,String specialDiscount,
    String globalDiscountPercentage, String globalDiscount,String vat,String vatLebanese,String total,
    ) async {
  final uri = Uri.parse(kStoreQuotationUrl);
  String token = await getAccessTokenFromPref();
  var response = await http.post(
    uri,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    },
      body: {
      "manualReference":manualReference,
      "clientId":clientId,
      "validity":validity,
      "paymentTerm":paymentTerm,
      "priceList":priceList,
      "currency":currency,
      "termsAndConditions":termsAndConditions,
      "salespersonId":salespersonId,
      "commissionMethodId":commissionMethodId,
      "cashingMethodId":cashingMethodId,
      "commissionRate":commissionRate,
      "commissionTotal":commissionTotal,
      "totalBeforeVat":totalBeforeVat,
        "specialDiscountPercentage": specialDiscountPercentage,
        "specialDiscount":specialDiscount ,
        "globalDiscountPercentage": globalDiscountPercentage,
        "globalDiscount":globalDiscount ,
        "vat": vat,
        "vatLebanese": vatLebanese,
        "total":total
      }
  );

  var p = json.decode(response.body);
  return p;//p['success']==true
}
