import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/cash_trays_controller.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../../../Widgets/custom_snak_bar.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import 'cash_tray_report.dart';

class SelectCashTrayNumberDialog extends StatefulWidget {
  const SelectCashTrayNumberDialog({super.key});

  @override
  State<SelectCashTrayNumberDialog> createState() =>
      _SelectCashTrayNumberDialogState();
}

class _SelectCashTrayNumberDialogState
    extends State<SelectCashTrayNumberDialog> {
  CashTraysController cashTraysController = Get.find();
  HomeController homeController = Get.find();
  TextEditingController selectedCashTrayNumberController =
      TextEditingController();
@override
  void initState() {
  cashTraysController.getCashTraysFromBack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width:homeController.isMobile.value? MediaQuery.of(context).size.width * 0.8:MediaQuery.of(context).size.width * 0.3,
      height:homeController.isMobile.value? MediaQuery.of(context).size.height * 0.3: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<CashTraysController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogTitle(text: 'select_cash_tray_number'.tr),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: CircleAvatar(
                    backgroundColor: Primary.primary,
                    radius: 15,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            gapH32,
            DropdownMenu<String>(
              width:homeController.isMobile.value? MediaQuery.of(context).size.width * 0.5:MediaQuery.of(context).size.width * 0.25,
              // requestFocusOnTap: false,
              enableSearch: true,
              controller: selectedCashTrayNumberController,
              hintText: '${'search'.tr}...',
              inputDecorationTheme: InputDecorationTheme(
                // filled: true,
                hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                // outlineBorder: BorderSide(color: Colors.black,),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
              ),
              // menuStyle: ,
              menuHeight: 250,
              dropdownMenuEntries: controller.cashTraysNumbersList
                  .map<DropdownMenuEntry<String>>((String option) {
                return DropdownMenuEntry<String>(
                  value: option,
                  label: option,
                );
              }).toList(),
              enableFilter: true,
              onSelected: (String? val) {
                var index = controller.cashTraysNumbersList.indexOf(val!);
                controller
                    .setSelectedCashTrayName(val);
                controller
                    .setSelectedCashTrayId(controller.cashTraysIdsList[index]);
              },
            ),
            gapH20,
            ReusableButtonWithColor(
                btnText: 'apply'.tr,
                radius: 9,
                onTapFunction: () async {
                  if (selectedCashTrayNumberController.text != '' &&
                      controller.cashTraysNumbersList
                          .contains(selectedCashTrayNumberController.text)) {
                    var res = await controller.getCashTrayReportFromBack(controller.selectedCashTrayId);
                    if (res['success'] == true) {
                      // print('res $res');
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const CashTraysReport();
                      }));
                    } else {
                      CommonWidgets.snackBar('error', res['message']);
                    }
                  } else {
                    CommonWidgets.snackBar(
                        'error', 'select_cash_tray_from_menu'.tr);
                  }
                },
                width:homeController.isMobile.value? MediaQuery.of(context).size.width * 0.5: MediaQuery.of(context).size.width * 0.25,
                height: 50)
          ],
        );
      }),
    );
  }
}
