import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/CashTrayBackend/get_open_cash_tray_id.dart';

import '../Backend/Sessions/get_open_session_id.dart';
import '../Backend/orders/get_orders.dart';
import '../Backend/orders/retrieve.dart';
import '../Locale_Memory/save_user_info_locally.dart';




class OrdersController extends GetxController {
  List<String> filtersList = ['All Docs','Partially Paid', 'Pending', 'Paid'];
  List orders = [];
  List retrieveOrders = [];
  bool isOrdersFetched = false;
  bool isRetrieveOrdersFetched = false;
  TextEditingController searchControllerInRetrieve = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController filterController = TextEditingController();


  String selectedOrderId='';
  setSelectedOrderId(String value){
    selectedOrderId=value;
    update();
  }

  String selectedDocId='';
  int selectedDocIndex=-1;
  List selectedDoc=[];
  setSelectedDocIdAndIndex(String value,int index){
    selectedDocId=value;
    selectedDocIndex=index;
    update();
  }
  setSelectedDoc(List value){
    selectedDoc=value;
    update();
  }

  Map selectedOrder={};
  setSelectedOrder(Map value){
    selectedOrder=value;
    update();
  }

  setIsOrdersFetched(bool value) {
    isOrdersFetched = value;
    update();
  }

  setOrders(List value) {
    orders = value;
    update();
  }
  setIsRetrieveOrdersFetched(bool value) {
    isRetrieveOrdersFetched = value;
    update();
  }

  setRetrieveOrders(List value) {
    retrieveOrders = value;
    update();
  }

  getAllOrdersFromBack() async {
    orders = [];
    isOrdersFetched = false;
    selectedDocIndex = -1;
    var p = await getAllOrders(searchController.text,filterController.text);
    orders = p;
    orders = orders.reversed.toList();
    isOrdersFetched = true;
    update();
  }

  getAllOrdersForRetrieveFromBack() async {
    retrieveOrders = [];
    isRetrieveOrdersFetched = false;
    var currentSessionId = '';
    var session = await getOpenSessionId();
    if ('${session['data']}' != '[]') {
        currentSessionId = '${session['data']['session']['id']}';
    }
    var userId=await getIdFromPref();
    var cashTrayId='';
    var cashTrayRes=await getOpenCashTrayId(currentSessionId,userId);
    if ('$cashTrayRes' !='[]') {
      cashTrayId = '${cashTrayRes['id']}';
    }
    var p = await retrieve(searchControllerInRetrieve.text,currentSessionId,cashTrayId);
    retrieveOrders = p;
    retrieveOrders = retrieveOrders.reversed.toList();
    isRetrieveOrdersFetched = true;
    update();
  }

}
