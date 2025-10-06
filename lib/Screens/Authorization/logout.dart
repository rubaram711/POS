import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/orders_controller.dart';
import 'package:pos_project/Controllers/pos_controller.dart';
import 'package:pos_project/Screens/Authorization/sign_up_screen.dart';
import '../../Controllers/cash_trays_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Controllers/role_controller.dart';
import '../../Controllers/session_controller.dart';
import '../../Controllers/transfer_controller.dart';
import '../../Controllers/warehouse_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/colors.dart';



class LogoutBtn extends StatefulWidget {
  const LogoutBtn({super.key});

  @override
  State<LogoutBtn> createState() => _LogoutBtnState();
}

class _LogoutBtnState extends State<LogoutBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return const SignInScreen();
            }));
        await saveUserInfoLocally('', '', '', '', '','','','','','');
        await saveCompanySettingsLocally('', '','', '', '', '', '','','','','', );
        await saveHeader1Locally('', '','', '', '', '', '','','','','','','','','' );
        await saveRoleIdInfoLocally('');
        await saveRoleNameInfoLocally('');
        await savePosIdInfoLocally('');
        await savePosNameInfoLocally('');
        await saveWarehouseIdInfoLocally('');
        await saveRolesLocally([]);
        Get.delete<HomeController>(force: true);
        Get.delete<ProductController>(force: true);
        Get.delete<PaymentController>(force: true);
        Get.delete<TransferController>(force: true);
        Get.delete<WarehouseController>(force: true);
        Get.delete<SessionController>(force: true);
        Get.delete<OrdersController>(force: true);
        Get.delete<CashTraysController>(force: true);
        Get.delete<RoleController>(force: true);
        Get.delete<PossController>(force: true);
        Get.put(HomeController());
        Get.put(ProductController());
        Get.put(PaymentController());
        Get.put(TransferController());
        Get.put(WarehouseController());
        Get.put(SessionController());
        Get.put(OrdersController());
        Get.put(CashTraysController());
        Get.put(RoleController());
        Get.put(PossController());
      },
      child: Text('logout'.tr,style: TextStyle(color: Primary.primary,fontSize: 16),),
    );
  }
}
