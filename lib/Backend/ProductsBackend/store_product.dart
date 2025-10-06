import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/urls.dart';

Future storeProduct(
    int warehouseId,
    int itemTypeId,
    String mainCode,
    int taxationGroupId,
    String itemCodesType,
    String itemCodesCode,
    int itemCodesPrint,
    String mainDescription,
    String shortDescription,
    String secondLanguageDescription,
    // String taxationGroupId,
    int subrefId,
    int canBeSold,
    int canBePurchased,
    int warranty,
    String lastAllowedPurchaseDate,//todo:send as date
    double unitCost,
    int decimalCost,
    int currencyId,
    int quantity,
    double unitPrice,
    int decimalPrice,
    double lineDiscountLimit,
    int packageId,
    String packageUnitName,
    String packageUnitQuantity,
    String packageSetName,
    String packageSetQuantity,
    String packageSupersetName,
    String packageSupersetQuantity,
    String packagePaletteName,
    String packagePaletteQuantity,
    String packageContainerName,
    String packageContainerQuantity,
    int decimalQuantity,
    List itemGroups,
    int discontinued,
    ) async {
  final uri = Uri.parse(kAddProductUrl);
  String token = await getAccessTokenFromPref();
  var response = await http.post(uri, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token"
  }, body: {
    "warehouseId": '$warehouseId',
    "itemTypeId": '$itemTypeId',//todo ???
    "mainCode": mainCode,
    "taxationGroupId": '$taxationGroupId',
    // "itemCodes[0][type]": itemCodesType,
    // "itemCodes[0][code]": itemCodesCode,
    // "itemCodes[0][print]": itemCodesPrint,
    "main_description": mainDescription,
    "shortDescription": shortDescription,
    "second_language_description": secondLanguageDescription,
    "subrefId": '$subrefId',
    "canBeSold": '$canBeSold',
    "canBePurchased": '$canBePurchased',
    "warranty": '$warranty',
    "lastAllowedPurchaseDate": lastAllowedPurchaseDate,
    "unitCost": '$unitCost',
    "decimalCost": '$decimalCost',
    "currencyId": '$currencyId',
    "quantity": '$quantity',
    "unitPrice": '$unitPrice',
    "decimalPrice": '$decimalPrice',
    "lineDiscountLimit": '$lineDiscountLimit',
    "packageId": '$packageId',
    "packageUnitName": packageUnitName,
    "packageUnitQuantity": packageUnitQuantity,
    "packageSetName": packageSetName,
    'packageSetQuantity': packageSetQuantity,
    'packageSupersetName': packageSupersetName,
    'packageSupersetQuantity': packageSupersetQuantity,
    'packagePaletteName': packagePaletteName,
    'packagePaletteQuantity': packagePaletteQuantity,
    'packageContainerName': packagePaletteName,
    'packageContainerQuantity': packagePaletteQuantity,
    'decimalQuantity': '$decimalQuantity',
    // 'itemGroups': '[1]',
    'discontinued': '$discontinued',
  });

  var p = json.decode(response.body);

  return p; //p['success']==true
}
