import 'package:get/get.dart';

import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Models/role_model.dart';

class RoleController extends GetxController {
  String selectedRoleId = '';
  String selectedRoleName = '';

  // List roles = [];
  List<Role> roles=[];
  bool isRolesFetched=false;
  getRoles() async {
    roles=await getRolesFromPref();
    isRolesFetched=true;
    update();
  }

  setSelectedRoleId(String newValue) {
    selectedRoleId = newValue;
    update();
  }

  setSelectedRoleName(String newValue) {
    selectedRoleName = newValue;
    update();
  }

  // saveRoles(List newRoles) {
  //   roles = newRoles;
  //   print(roles);
  //   update();
  // }
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
