import 'package:flutter/material.dart';
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
import '../../translation/localization/locale_service.dart';
import '../Authorization/sign_up_screen.dart';

import 'package:get/get.dart';

import '../../Controllers/home_controller.dart';
import '../../Controllers/role_controller.dart';


class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLang= 'eng'.tr;
  int selectedCurrIndex= 1;
  // LanguagesController languagesController=Get.find();
  getLang()async{
    Locale? savedLocale = await LocaleService.getSavedLocale();
if(savedLocale==Locale('en')) {
  setState(() {
    selectedLang = 'eng'.tr;
  });
}else {
  setState(() {
    selectedLang = 'arb'.tr;
  });
}
  }
  @override
  void initState() {
    getLang();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH20,
              Text("settings".tr, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),

              SizedBox(height: Sizes.deviceHeight*0.02,),

              _optionGroup(title: "language".tr, options: ["arb".tr, "eng".tr]),
              gapH12,
              _optionGroup(title: "currency".tr, options: ["USD", "LBP"]),

              SizedBox(height: Sizes.deviceHeight*0.02,),

              _settingsCard(),

              SizedBox(height: Sizes.deviceHeight*0.02,),

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
  }

  Widget _optionGroup({
    required String title,
    required List<String> options,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Row(
            children: List.generate(options.length, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child:title=="language".tr? _optionLangButton(options[index], index): _optionButton(options[index], index),
              );
            }),
          ),
        ],
      ),
    );
  }
  void changeLanguage(String languageCode) async {
    Locale locale = Locale(languageCode);
    await LocaleService.saveLanguageCode(languageCode);
    Get.updateLocale(locale);
  }

  Widget _optionLangButton(String label, int index) {
    return InkWell(
      onTap: (){
        setState(() {
          selectedLang=label;
        });
       if( label=='eng'.tr){
          // controller.setLanguage('en');
          changeLanguage('en');
        }else{
          // controller.setLanguage('ar');
          changeLanguage('ar');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selectedLang==label ? Primary.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Primary.primary ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:  selectedLang==label ? Colors.white : Primary.primary ,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  Widget _optionButton(String label, int index) {
    return InkWell(
      onTap:(){},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: index==1 ? Primary.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Primary.primary ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: index==1 ? Colors.white : Primary.primary ,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _settingsCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          _settingsItem(Icons.integration_instructions, "integrations".tr),
          _settingsItem(Icons.print, "printer_settings".tr),
          _settingsItem(Icons.barcode_reader, "scanner_settings".tr),
          _settingsItem(Icons.article, "terms_and_conditions".tr),
          _settingsItem(Icons.help, "help_center".tr),
        ],
      ),
    );
  }

  Widget _settingsItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Primary.primary ),
          SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 16, color: Primary.primary , fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}