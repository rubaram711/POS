import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/CashTrayBackend/get_cash_tray.dart';

import '../Backend/CashTrayBackend/create_cash_tray.dart';
import '../Backend/CashTrayBackend/get_cash_tray_report.dart';
import '../Backend/Sessions/get_open_session_id.dart';

class CashTraysController extends GetxController {
  int selectedTabIndex = 0;
  TextEditingController searchInCashTraysController = TextEditingController();

  List cashTraysList = [];
  List<String> cashTraysNumbersList = [];
  List<String> cashTraysIdsList = [];
  String selectedCashTrayId = '';
  String selectedCashTrayName = '';
  bool isCashTraysFetched = false;
  // resetValues(){
  //   warehousesList = [];
  //   warehousesNameList = [];
  //   warehouseIdsList = [];
  //   isWarehousesFetched = false;
  //   update();
  // }

  setSelectedCashTrayId(String val) {
    selectedCashTrayId = val;
    update();
  }
  setSelectedCashTrayName(String val) {
    selectedCashTrayId = val;
    update();
  }

  getCashTraysFromBack() async {
    cashTraysList = [];
    cashTraysNumbersList = [];
    cashTraysIdsList = [];
    isCashTraysFetched = false;
    var p = await getAllCashTraies(searchInCashTraysController.text);
    if ('$p' != '[]') {
      cashTraysList = p;
      cashTraysList=cashTraysList.reversed.toList();
      for (var v in p) {
        cashTraysNumbersList.add(v['tray_number']);
        cashTraysIdsList.add('${v['id']}');
      }
      cashTraysNumbersList=cashTraysNumbersList.reversed.toList();
      cashTraysIdsList=cashTraysIdsList.reversed.toList();
    }
    isCashTraysFetched = true;
    update();
  }

  String cashTrayNumber = '';
  getCashTrayNumberFromBack() async {
    var currentSessionId = '';
    var session = await getOpenSessionId();
    if ('${session['data']}' != '[]') {
      currentSessionId = '${session['data']['session']['id']}';
      var p = await getFieldsForCreateCashTray(currentSessionId);
      if ('$p' != '[]') {
        cashTrayNumber = p['trayNumber'];
      }
    }
    update();
  }

  Map report = {};
  int cashingMethodsListLength=0;
  List<Map<String, dynamic>> sortedSalesReport =[];
  List<Map<String, dynamic>> sortedWasteReport =[];

  Future getCashTrayReportFromBack(String cashTrayNumber) async {
    var currentSessionId = '';
    var session = await getOpenSessionId();
    if ('${session['data']}' != '[]') {
      currentSessionId = '${session['data']['session']['id']}';
    }
    var res = await getCashTrayReport(cashTrayNumber, currentSessionId);
    if (res['success'] == true) {
      report = res['data'];
      List cashingMethodsList=report['cashingMethodsTotals']??[];
      cashingMethodsListLength=cashingMethodsList.length;
      sortedSalesReport =
      List<Map<String, dynamic>>.from(
          report['salesReport'] ?? [])
        ..sort((a, b) => (b['qty'] as num).compareTo(a['qty'] as num));
      sortedWasteReport =
      List<Map<String, dynamic>>.from(
          report['wasteReport'] ?? [])
        ..sort((a, b) => (b['qty'] as num).compareTo(a['qty'] as num));
      update();
    }
    return res;
  }


  setSelectedTabIndex(int val) {
    selectedTabIndex = val;
    update();
  }


}
