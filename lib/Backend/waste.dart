import 'package:dio/dio.dart';
import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../const/urls.dart';

Future waste(
    Map items,
    String sessionId,
    ) async {
  String token = await getAccessTokenFromPref();
  String posTerminal = await getPosTerminalIdFromPref();
  FormData formData = FormData.fromMap({
    "sessionId": sessionId,
    "posTerminalId": posTerminal,
    // "note": note,
  });

  var itemsKeys = items.keys.toList();

  for (int i = 0; i < itemsKeys.length; i++) {
    formData.fields.addAll([
      MapEntry("items[$i][id]", '${items[itemsKeys[i]]['id']}'),
      MapEntry("items[$i][wastedQty]", '${items[itemsKeys[i]]['quantity']}'),
    ]);
  }

  Response response = await Dio()
      .post(kWasteUrl,
      data: formData,
      options: Options(headers: {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }))
  // ignore: body_might_complete_normally_catch_error
      .catchError((err) {
    // ignore: avoid_print
    print('100ااا');
    // ignore: avoid_print
    print(err.response);
  });
  return response.data;
  // if (response.statusCode == 200) {
  //   return response.data['data'];
  // } else {
  //   return 'error';
  // }
}
