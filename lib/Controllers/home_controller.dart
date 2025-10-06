import 'package:get/get.dart';


class HomeController extends GetxController {
  bool isItGarage=false;
  bool isWifiConnected=true;
  bool isTablet=false;
  final isMobile=false.obs;

  setIsItGarage(bool value){
    isItGarage=value;
    update();
  }

  setIsWifiConnected(bool value){
    isWifiConnected=value;
    update();
  }

  setIsTablet(bool value){
    isTablet=value;
    update();
  }

  String useName = '';
  setName(String value){
    useName=value;
    update();
  }

  bool isSessionToday=true;

  var companySubjectToVat = '1';
  var vat = '';
  var companyName = '';
  var companyAddress = '';
  var posName = '';
  String date='';
  String currentSessionNumber = '',currentCashTrayNumber='';
  setCompanyName(String val){
    companyName=val;
    update();
  }
  setPosName(String val){
    posName=val;
    update();
  }
  setDate(String val){
    date=val;
    update();
  }
  setCurrentSessionNumber(String val){
    currentSessionNumber=val;
    update();
  }
  setCurrentCashTrayNumber(String val){
    currentCashTrayNumber=val;
    update();
  }

  final isCurrenciesFetched = false.obs;



  final isOpened = true.obs;
  final selectedTab = 'Home'.obs;
  toggleIsOpenedValue() {
    isOpened.value = !isOpened.value;
    update();
  }
  setSelectedTab(String newVal){
    selectedTab.value=newVal;
  }

  final selectedAppBarItem='Dine In'.obs;

  final orderList=[].obs;
  final orderCounters={}.obs;
  addToOrder(Map item){
    orderList.add(item);
    orderCounters['${item['id']}'].value=1;
    update();
  }
  
  addToCounterProduct(int id,int count){
    orderCounters['$id'].value=count;
  }





}
