import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../const/urls.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';

Future addOrder(
  Map items,
  String usdTaxValue,
  String usdDiscountValue,
  String otherCurrencyTaxValue,
  String otherCurrencyDiscountValue,
  String usdTotal,
  String otherCurrencyTotal,
  String discountTypeId,
  String sessionId,
  String note,
    bool isDiscountIsGranted,
    String clientId,
    String cashTrayId,
    String totalDiscountAsPercent
) async {
  // print('go in $discountTypeId');
  // // print('go in $isDiscountIsGranted');
  // print('go in $usdDiscountValue');
  // print('go in $otherCurrencyDiscountValue');
  ProductController productController=Get.find();
  String token = await getAccessTokenFromPref();
  String posTerminal = await getPosTerminalIdFromPref();
  String posCurrencyId = await getCompanyPosCurrencyIdFromPref();
  String primaryCurrencyId = await getCompanyPrimaryCurrencyIdFromPref();
Map<String,dynamic> body={
  'cashTrayId':cashTrayId,
  "clientId":clientId,
  "primaryCurrencyTaxValue": usdTaxValue,
  "primaryCurrencyDiscountValue":isDiscountIsGranted || discountTypeId=='-2' ? '0': usdDiscountValue,
  "posCurrencyTaxValue": otherCurrencyTaxValue,
  "posCurrencyDiscountValue":isDiscountIsGranted || discountTypeId=='-2' ?'0': otherCurrencyDiscountValue,
  "primaryCurrencyTotal": usdTotal,
  "posCurrencyTotal": otherCurrencyTotal,
  "sessionId": sessionId,
  "discountTypeId":discountTypeId=='-2'?'0':isDiscountIsGranted?'': discountTypeId,
  "posTerminalId": posTerminal,
  "note": note,
  'primaryCurrencyGrantedDiscount':isDiscountIsGranted?usdDiscountValue:'0',
  'posCurrencyGrantedDiscount':isDiscountIsGranted?otherCurrencyDiscountValue:'0',
  "primaryCurrencyId": primaryCurrencyId,
  "posCurrencyId": posCurrencyId,
  "primaryCurrencyRate": '1',//productController.primaryCurrencyLatestRate,
  "posCurrencyRate": productController.posCurrencyLatestRate,
};
if(discountTypeId=='-2'){
  body.addAll({
    'customDiscountPercentage':totalDiscountAsPercent,
    'posCurrencyCustomDiscountValue':otherCurrencyDiscountValue,
  });
}
  FormData formData = FormData.fromMap(body);

  var itemsKeys = items.keys.toList();

  for (int i = 0; i < itemsKeys.length; i++) {
    formData.fields.addAll([
      MapEntry("items[$i][id]", '${items[itemsKeys[i]]['id']}'),
      MapEntry("items[$i][quantity]", '${items[itemsKeys[i]]['sign']??''}${items[itemsKeys[i]]['quantity']}'),
      MapEntry("items[$i][priceAfterTax]", '${items[itemsKeys[i]]['price']}'),
      MapEntry("items[$i][itemDiscount]", '${items[itemsKeys[i]]['discount']}'),
      MapEntry("items[$i][DiscountTypeId]",
          '${items[itemsKeys[i]]['discount_type_id']}'),
    ]);
  }

  Response response = await Dio()
      .post(kOrdersUrl,
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
  // print('object ${response.statusCode} ${response.data}');
  if (response.statusCode == 200) {
    return response.data['data'];
  } else {
    return 'error';
  }
}
