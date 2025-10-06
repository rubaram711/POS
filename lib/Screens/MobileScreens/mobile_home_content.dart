import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/CashTray/cash_tray_options.dart';
import 'package:pos_project/Screens/Sessions/sessions_options.dart';
import 'package:pos_project/const/Sizes.dart';
import 'package:pos_project/const/colors.dart';
import '../../Controllers/cash_trays_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/pos_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Controllers/session_controller.dart';
import '../../Controllers/transfer_controller.dart';
import '../../Controllers/warehouse_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../Authorization/sign_up_screen.dart';


import '../../Controllers/home_controller.dart';
import '../../Controllers/role_controller.dart';
import 'mobile_docs.dart';



class MobileHomeContent extends StatefulWidget {
  const MobileHomeContent({super.key});

  @override
  State<MobileHomeContent> createState() => _MobileHomeContentState();
}

class _MobileHomeContentState extends State<MobileHomeContent> {
  int selectedMenuIndex = 0;
  int hoveredCategoryIndex = -1;
  SessionController sessionController=Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (proCont) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
              children: [
                gapH40,
                HomeOptionCard(onTapFunc: (){
                  // Get.to(MobileHomeContent());
                },title: "dashboard".tr),
                gapH16,
                HomeOptionCard(onTapFunc: (){
                  Get.to(()=>SessionsOptions());
                },title:"sessions".tr),
              gapH16,
                HomeOptionCard(onTapFunc: (){
                  Get.to(()=>CashTrayOptions());
                },title:"cash_tray".tr),
                gapH16,
                HomeOptionCard(onTapFunc: (){
                  Get.to(()=>MobileDocs());
                },title:"docs".tr),
                gapH20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("version".tr, style: TextStyle(fontSize: 14)),
                    Text("2.0", style: TextStyle(fontSize: 14)),
                  ],
                ),

                Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text("log_out".tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:  () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const SignInScreen();
                          },
                        ),
                      );
                      await saveUserInfoLocally(
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                      );
                      await saveCompanySettingsLocally(
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                      );
                      await saveHeader1Locally('', '','', '', '', '', '','','','','','','','','' );
                      await saveRoleIdInfoLocally('');
                      await saveRoleNameInfoLocally('');
                      await savePosIdInfoLocally('');
                      await savePosNameInfoLocally('');
                      await saveWarehouseIdInfoLocally('');
                      await saveRolesLocally([]);
                      Get.delete<HomeController>(force: true);
                      Get.delete<ProductController>(
                        force: true,
                      );
                      Get.delete<PaymentController>(
                        force: true,
                      );
                      Get.delete<TransferController>(
                        force: true,
                      );
                      Get.delete<WarehouseController>(
                        force: true,
                      );
                      Get.delete<SessionController>(
                        force: true,
                      );
                      Get.delete<OrdersController>(
                        force: true,
                      );
                      Get.delete<CashTraysController>(
                        force: true,
                      );
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
                      // Get.reload<HomeController>();
                    },
                  ),
                ),
              ],
            ),
        );

      },
    );
  }




}

class HomeOptionCard extends StatelessWidget {
  const HomeOptionCard({super.key, required this.title, required this.onTapFunc});
  final String title;
  final Function onTapFunc;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
onTapFunc();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Primary.primary , fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

