import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Backend/orders/add_order.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading_dialog.dart';
import '../../Widgets/reusable_text_field.dart';
import 'home_content.dart';



class EnterNoteDialog extends StatefulWidget {
  const EnterNoteDialog({super.key});

  @override
  State<EnterNoteDialog> createState() =>
      _EnterNoteDialogState();
}

class _EnterNoteDialogState extends State<EnterNoteDialog> {
  // List discountTypesList=[
  //   'complete',
  //   'complete',
  //   'complete',
  // ];
  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();
  ClientController clientController = Get.find();

  @override
  Widget build(BuildContext context) {
    noteController.clear();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.32,
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<ProductController>(builder: (proCont) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DialogTitle(text: 'Enter Note'.tr),
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
              ReusableTextField
                (onChangedFunc: (value){
                  noteController.text=value;
              },
                  validationFunc:  (value){},
                  hint: '',
                  isPasswordField: false,
                  textEditingController: noteController),
              gapH20,
              ReusableButtonWithColor(
                  btnText: 'apply'.tr,
                  radius: 9,
                  onTapFunction: () async {
                    // if (proCont.orderItemsList.isNotEmpty) {

                        proCont.setIsClickedPark(true);

                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => const AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                              ),
                              elevation: 0,
                              content: LoadingDialog()));
                      var currentSessionId = '';
                      var res = await getOpenSessionId();
                      if ('${res['data']}' != '[]') {
                        currentSessionId = '${res['data']['session']['id']}';
                      }
                        var userId = await getIdFromPref();
                        var cashTrayId = '';
                        var cashTrayRes = await getOpenCashTrayId(
                            currentSessionId, userId);
                        if ('$cashTrayRes' != '[]') {
                          cashTrayId = '${cashTrayRes['id']}';
                        }
                      var p = await addOrder(
                          productController.orderItemsList,
                          productController.taxesSumWithExchange
                              .toStringAsFixed(2),
                          productController.orderItemsList.isNotEmpty
                              ? '${productController.totalDiscountWithExchange}'
                              : '0',
                          productController.taxesSum.toStringAsFixed(2),
                          productController.orderItemsList.isNotEmpty
                              ? '${productController.totalDiscount}'
                              : '0',
                          productController.totalPriceWithExchange
                              .toStringAsFixed(2),
                          productController.totalPrice.toStringAsFixed(2),
                          productController.selectedDiscountTypeId == '0'
                              ? ''
                              : productController.selectedDiscountTypeId,
                          currentSessionId,
                          noteController.text,
                          productController.selectedDiscountTypeId == '-1'?true:false,
                        clientController
                            .selectedCustomerIdWithOk ==
                            '-1'
                            ? ''
                            : clientController
                            .selectedCustomerIdWithOk,
                        cashTrayId,
                          productController.totalDiscountAsPercent.toString(),
                          clientController.selectedCarId
                      );
                      Get.back();
                      if (p != 'error') {
                        // paymentController.resetAll();
                        Get.back();
                        productController.resetAll();
                        clientController.resetAll();
                        CommonWidgets.snackBar('success',
                            'The order ${p['orderNumber']} parked successfully'); //todo change
                      } else {
                        Get.back();
                        CommonWidgets.snackBar('error', 'error'.tr);
                      }
                        proCont.setIsClickedPark(false);
                    // }

                  },
                  width: MediaQuery.of(context).size.width ,
                  height: 50)
            ],
          ),
        );
      }),
    );
  }
}
