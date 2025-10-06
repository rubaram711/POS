import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../const/urls.dart';


Future finishOrder(
    String roleName,
    String cashTrayId,
    String orderId,
    List cashingMethods,
    String usdChange,
    String otherCurrencyChange,
    String usdRemaining,
    String otherCurrencyRemaining,
    String clientId,
    String sessionId
    ) async {
  // print('orderId $orderId');
  // print('cashTrayId $cashTrayId');
  // print('clientId $clientId');
  // print('usdChange $usdChange');
  // print('otherCurrencyChange $otherCurrencyChange');
  // print('usdRemaining $usdRemaining');
  // print('otherCurrencyRemaining $otherCurrencyRemaining');
  // print('cashTrayId $cashTrayId');
  // print('sessionId $sessionId');
ProductController productController=Get.find();
  String token = await getAccessTokenFromPref();
  FormData formData = FormData.fromMap({
    "clientId":clientId,
    "primaryCurrencyChange":Decimal.parse(usdChange),
    "posCurrencyChange":Decimal.parse(otherCurrencyChange),
    "primaryCurrencyRemaining": Decimal.parse(usdRemaining),
    "posCurrencyRemaining": Decimal.parse(otherCurrencyRemaining),
    'cashTrayId':cashTrayId,
    'sessionId':sessionId,
    'roleName':roleName,
  });

  for (int i = 0; i < cashingMethods.length; i++) {

      if (productController.posCurrency == productController.primaryCurrency) {
        formData.fields.addAll([
          MapEntry("cashingMethods[$i][id]", '${cashingMethods[i]['id']}'),
          MapEntry("cashingMethods[$i][authCode]", '${cashingMethods[i]['authCode']}'),
          MapEntry(
              "cashingMethods[$i][primaryCurrencyAmount]", '${cashingMethods[i]['price']}'),
          MapEntry("cashingMethods[$i][posCurrencyAmount]", '${cashingMethods[i]['price']}'),
        ]);
      } else if (cashingMethods[i]['currency'] == productController.primaryCurrency) {
        formData.fields.addAll([
          MapEntry("cashingMethods[$i][id]", '${cashingMethods[i]['id']}'),
          MapEntry("cashingMethods[$i][authCode]", '${cashingMethods[i]['authCode']}'),
          MapEntry(
              "cashingMethods[$i][primaryCurrencyAmount]", '${cashingMethods[i]['price']}'),
          MapEntry("cashingMethods[$i][posCurrencyAmount]", '0'),
        ]);
      } else {
        formData.fields.addAll([
          MapEntry("cashingMethods[$i][id]", '${cashingMethods[i]['id']}'),
          MapEntry("cashingMethods[$i][authCode]", '${cashingMethods[i]['authCode']}'),
          MapEntry("cashingMethods[$i][primaryCurrencyAmount]", '0'),
          MapEntry("cashingMethods[$i][posCurrencyAmount]",
              '${cashingMethods[i]['price']}'),
        ]);
      }
  }

  Response response = await Dio().post(
      '$kFinishOrderUrl/$orderId',
      data: formData,
      options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }
      )
  // ignore: body_might_complete_normally_catch_error
  )      .catchError((err) {
    // ignore: avoid_print
    print('100 ${err.response}');
    return err.response;
  });
  // print('finish');
  // print(response.data);
  return response.data;
}

//{id: 35, user_id: 6, company_id: 1,
// payment_term_id: null, cashing_method_id: null,
// discount_type_id: null, client_id: 1, finished_by_user_id: 6,
// order_number: O240000027, doc_number: S24023-POS001-27,
// session_id: 23, payment_status: null, type: null, status: paid,
// delivery_status: pending, note: null, usd_tax_value: 14864.86, usd_discount_value: 0,
// other_currency_tax_value: 1330405405.41, other_currency_discount_value: 0, final_payment_date: null,
// usd_total: 150000, other_currency_total: 13425000000, usd_remaining: 0,
// other_currency_remaining: 0, usd_change: 0, other_currency_change: 0,
// created_at: 2024-10-27T11:22:57.000000Z, updated_at: 2024-10-27T11:23:01.000000Z, deleted_at: null}