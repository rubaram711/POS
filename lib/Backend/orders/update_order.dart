import 'package:dio/dio.dart';
import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../const/urls.dart';

Future updateOrder(
    Map items,
    String orderId,
    String usdTaxValue,
    String usdDiscountValue,
    String otherCurrencyTaxValue,
    String otherCurrencyDiscountValue,
    String usdTotal,
    String otherCurrencyTotal,
    String discountTypeId,
    String sessionId,
    String note,
    ) async {
  // print('go in $usdDiscountValue');
  // print('go in $otherCurrencyDiscountValue');
  // print('go in $otherCurrencyDiscountValue');
  String token = await getAccessTokenFromPref();
  String posTerminal = await getPosTerminalIdFromPref();
  FormData formData = FormData.fromMap({
    "usdTaxValue": usdTaxValue,
    "usdDiscountValue": usdDiscountValue,
    "otherCurrencyTaxValue": otherCurrencyTaxValue,
    "otherCurrencyDiscountValue": otherCurrencyDiscountValue,
    "sessionId": sessionId,
    "discountTypeId": discountTypeId,
    "posTerminalId": posTerminal,
    "note": note,
  });

  var itemsKeys = items.keys.toList();

  for (int i = 0; i < itemsKeys.length; i++) {
    formData.fields.addAll([
      MapEntry("items[$i][id]", '${items[itemsKeys[i]]['id']}'),
      MapEntry("items[$i][quantity]", '${items[itemsKeys[i]]['quantity']}'),
      MapEntry("items[$i][priceAfterTax]", '${items[itemsKeys[i]]['price']}'),
      MapEntry("items[$i][itemDiscount]", '${items[itemsKeys[i]]['discount']}'),
      MapEntry("items[$i][DiscountTypeId]",
          '${items[itemsKeys[i]]['discount_type_id']}'),
    ]);
  }

  Response response = await Dio()
      .post('$kUpdateOrdersUrl/$orderId',
      data: formData,
      options: Options(headers: {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }))
  // ignore: body_might_complete_normally_catch_error
      .catchError((err) {
    // ignore: avoid_print
    print('100');
    // ignore: avoid_print
    print(err.response);
  });
  // print('object11hfh $response.data');
  if (response.statusCode == 200) {
    return response.data['data'];
  } else {
    return 'error';
  }
}
