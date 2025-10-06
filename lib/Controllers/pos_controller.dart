import 'package:get/get.dart';

import '../../Backend/get_all_poss.dart';

class PossController extends GetxController {
  List posList = [];

  bool isPossFetched = false;
  String selectedPosId = '';
  String selectedPosName = '';

  getPossFromBack() async {
    posList = [];

    isPossFetched = false;
    var p = await getAllPos('');
    if('$p' != '[]'){
      posList=p;
      posList=posList.reversed.toList();
    }
    isPossFetched = true;
    update();
  }

  setSelectedRoleId(String newValue) {
    selectedPosId = newValue;
    update();
  }

  setSelectedPosName(String newValue) {
    selectedPosName = newValue;
    update();
  }


}
















  // @override 
  //   void onInit() {
  //      // Here you can fetch you product from server
  //      super.onInit();
  //   }

  //   @override 
  //   void onReady() {
  //      super.onReady();
  //   }

  //   @override
  //   void onClose() { 
  //         // Here, you can dispose your StreamControllers
  //         // you can cancel timers
  //         super.onClose();
  //   }

    
    // roles['${selectedId['id']}'].value = 1;














  // var roleAdmin = 0;
  // var roleCashier = 0;

  // void loginAdmin() {
  //   roleAdmin = 1;
  //   update();
  // }

  // void loginCashier() {
  //   roleCashier = 2;
  //   update();
  // }
