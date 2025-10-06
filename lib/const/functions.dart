
import 'dart:math';

import 'package:intl/intl.dart';

String numberWithComma(String num)
{
RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
mathFunc(Match match) => '${match[1]},';
String result = num.replaceAllMapped(reg, mathFunc);
return result;
}


String convertTimeZoneToDateAndTime(String timeZone) {
  DateTime dateTime = DateTime.parse(timeZone);
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.toLocal());

  return formattedDate; // Output: 04/03/2025 14:29:23
}

// String calculateRateCur1ToCur2(double usdToCur1, double usdToCur2) {
//   if (usdToCur1 == 0) {
//     throw ArgumentError("USD to CUR1 rate cannot be zero.");
//   }
//   return (usdToCur2 / usdToCur1).toString();
// }



double roundUp(double value, int decimalPlaces) {
  // double helper=double.parse(value.toStringAsFixed(decimalPlaces));
  // return helper;
  final factor = pow(10, decimalPlaces);
  return (value * factor).ceil() / factor;
}


String calculateRateCur1ToCur2(double usdToCur1, double usdToCur2) {
  if (usdToCur1 == 0) {
    throw ArgumentError("USD to CUR1 rate cannot be zero.");
  }
  double result =(usdToCur2 / usdToCur1);
  return (result).toString();
}



List<String> generateYears() {
  int currentYear = DateTime.now().year;
  return List<String>.generate(
    currentYear - 1940 + 1,
        (index) => '${1940 + index}',
  ).reversed.toList();
}