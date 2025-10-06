// import 'package:decimal/decimal.dart';
// import 'package:dio/dio.dart';
// import '../../../Locale_Memory/save_user_info_locally.dart';
// import '../../../const/urls.dart';
//
//
// Future sendOrder(
//     Map items,
//     List cashingMethods,
//     String usdTaxValue,
//     String usdDiscountValue,
//     String otherCurrencyTaxValue,
//     String otherCurrencyDiscountValue,
//     String usdTotal,
//     String otherCurrencyTotal,
//     String discountTypeId,
//     String usdChange,
//     String otherCurrencyChange,
//     String usdRemaining,
//     String otherCurrencyRemaining,
//     String clientId
//     ) async {
//   // print('clientId${ clientId}');
//   String token = await getAccessTokenFromPref();
//   FormData formData = FormData.fromMap({
//      "usdTaxValue":usdTaxValue,
//      "usdDiscountValue":usdDiscountValue,
//      "otherCurrencyTaxValue":otherCurrencyTaxValue,
//      "otherCurrencyDiscountValue":otherCurrencyDiscountValue,
//      "usdTotal":usdTotal,
//      "otherCurrencyTotal":otherCurrencyTotal,
//      "discountTypeId":discountTypeId,
//      "clientId":clientId,
//      "usdChange":Decimal.parse(usdChange),
//      "otherCurrencyChange":Decimal.parse(otherCurrencyChange),
//      "usdRemaining": Decimal.parse(usdRemaining),
//      "otherCurrencyRemaining": Decimal.parse(otherCurrencyRemaining),
//   });
//
//   var itemsKeys = items.keys.toList();
//
//   for (int i = 0; i < itemsKeys.length; i++) {
//     formData.fields.addAll([
//       MapEntry("items[$i][id]",'${items[itemsKeys[i]]['id']}'),
//       MapEntry("items[$i][quantity]",'${items[itemsKeys[i]]['quantity']}'),
//       MapEntry("items[$i][priceAfterTax]",'${items[itemsKeys[i]]['price']}'),
//       MapEntry("items[$i][itemDiscount]",'${items[itemsKeys[i]]['discount']}'),
//       MapEntry("items[$i][DiscountTypeId]",'${items[itemsKeys[i]]['discount_type_id']}'),
//     ]);
//   }
//
//   // var methodsKeys = cashingMethods.keys.toList();
//
//   for (int i = 0; i < cashingMethods.length; i++) {
//     if(cashingMethods[i]['currency']=='USD'){
//       formData.fields.addAll([
//         MapEntry("cashingMethods[$i][id]",'${cashingMethods[i]['id']}'),
//         MapEntry("cashingMethods[$i][usdAmount]",'${cashingMethods[i]['price']}'),
//         MapEntry("cashingMethods[$i][otherCurrencyAmount]",'0'),
//       ]);
//     } else{
//       formData.fields.addAll([
//         MapEntry("cashingMethods[$i][id]",'${cashingMethods[i]['id']}'),
//         MapEntry("cashingMethods[$i][usdAmount]",'0'),
//         MapEntry("cashingMethods[$i][otherCurrencyAmount]",'${cashingMethods[i]['price']}'),
//       ]);
//     }
//
//   }
//
//   Response response = await Dio().post(
//       kSendOrderUrl,
//       data: formData,
//       options: Options(
//           headers: {
//             "Content-Type": "multipart/form-data",
//             "Accept": "application/json",
//             "Authorization": "Bearer $token"
//           }
//       )
//   // ignore: body_might_complete_normally_catch_error
//   )      .catchError((err) {
//     // ignore: avoid_print
//     print('100 ${err.response}');
//   });
//   String name='${response.data['data']['order_number']}';
//   if(response.statusCode == 200){
//     return name;
//   }else{
//     return 'error';
//   }
// }
//
