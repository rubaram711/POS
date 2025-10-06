import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Backend/Sessions/get_open_session_id.dart';
import '../Backend/Sessions/get_sessions.dart';




class SessionController extends GetxController {
  int selectedTabIndex = 0;
  // String currentOpenSessionId='';
  TextEditingController searchInSessionsController = TextEditingController();

  var currentSessionId='';
  bool isTheirOpenedSession=false;
  setIsTheirOpenedSession(bool newVal){
    isTheirOpenedSession=newVal;
    update();
  }
  getCurrentOpenSessionId() async {
    var p=await getOpenSessionId();
    if('${p['data']}'!='[]'){
      currentSessionId= '${p['data']['session']['id']}';
      isTheirOpenedSession=true;
      update();
    }else{
      currentSessionId= '';
      isTheirOpenedSession=false;
      update();
    }
  }

  List sessionsList = [];

  bool isSessionsFetched = false;
  // resetValues(){
  //   warehousesList = [];
  //   warehousesNameList = [];
  //   warehouseIdsList = [];
  //   isWarehousesFetched = false;
  //   update();
  // }



  getSessionsFromBack() async {
    sessionsList = [];
    isSessionsFetched = false;
      var p = await getAllSessions(searchInSessionsController.text);
      if('$p' != '[]'){
        sessionsList=p;
        sessionsList=sessionsList.reversed.toList();
      }
    isSessionsFetched = true;
      update();
  }

  // setActiveInWarehouse(String val, int index){
  //   warehousesList[index]['active']= val;
  //   update();
  // }

  setSelectedTabIndex(int val){
     selectedTabIndex = val;
     update();
  }

  // setCurrentOpenSessionId(String val){
  //   currentOpenSessionId = val;
  //    update();
  // }



}
