import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/CashTrayBackend/close_cash_tray.dart';
import 'package:pos_project/Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import 'package:pos_project/Backend/CashTrayBackend/open_cash_tray.dart';
import 'package:pos_project/Screens/CashTray/cash_tray_report.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../../../Backend/Sessions/get_open_session_id.dart';
import '../../../Controllers/cash_trays_controller.dart';
import '../../../Controllers/home_controller.dart';
import '../../../Controllers/products_controller.dart';
import '../../../Locale_Memory/save_user_info_locally.dart';
import '../../../Widgets/custom_snak_bar.dart';
import '../../../Widgets/loading_dialog.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../Home/search_dialog.dart';

class OpenCloseCashTray extends StatefulWidget {
  const OpenCloseCashTray({super.key});

  @override
  State<OpenCloseCashTray> createState() => _OpenCloseCashTrayState();
}

class _OpenCloseCashTrayState extends State<OpenCloseCashTray> {
  // final HomeController homeController = Get.find();
  final _formKey = GlobalKey<FormState>();
  TextEditingController usdAmount = TextEditingController();
  TextEditingController anotherCurrencyAmount = TextEditingController();
  TextEditingController anotherCurrencyNonCashAmount = TextEditingController();
  TextEditingController usdNonCashAmount = TextEditingController();
  CashTraysController cashTraysController = Get.find();
  HomeController homeController = Get.find();
  ProductController productController = Get.find();
  var cashTrayNumberForClose = '';
  getCashTrayNumberForClose() async {
    var currentSessionId = '';
    var session = await getOpenSessionId();
    if ('${session['data']}' != '[]') {
      currentSessionId = '${session['data']['session']['id']}';
    }
    var userId = await getIdFromPref();

    var cashTrayRes = await getOpenCashTrayId(currentSessionId, userId);
    if ('$cashTrayRes' != '[]') {
      // setState(() {
      cashTrayNumberForClose = '${cashTrayRes['cashTrayNumber']}';
      // });
    }
  }

  @override
  void initState() {
    getCashTrayNumberForClose();
    cashTraysController.getCashTrayNumberFromBack();
    cashTraysController.selectedTabIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rowWidth = homeController.isMobile.value?MediaQuery.of(context).size.width * 0.45:MediaQuery.of(context).size.width * 0.28;
    // double  textFieldWidth=homeController.isTablet? MediaQuery.of(context).size.width * 0.25: MediaQuery.of(context).size.width * 0.15;
    return GetBuilder<CashTraysController>(
      builder: (cont) {
        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.65,
          // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DialogTitle(text: 'open_close_cash_tray'.tr),
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
                    ),
                  ],
                ),
                gapH20,
                cashTrayNumberForClose.isEmpty && cont.selectedTabIndex != 0
                    ?Text(
                  'no_open_cash_tray'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ):Text(
                  '${'cash_tray_number'.tr}: ${cont.selectedTabIndex == 0 ? cont.cashTrayNumber : cashTrayNumberForClose}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                gapH10,
                Row(
                  children: [
                    ReusableTabOpenClose(
                      index: 0,
                      text: 'open_cash_tray'.tr,
                      onTapFunc: () {
                        // cont.setSelectedTabIndex(0);
                        usdAmount.text = '0';
                        anotherCurrencyAmount.text = '0';
                        anotherCurrencyNonCashAmount.text = '0';
                        usdNonCashAmount.text = '0';
                      },
                    ),
                    ReusableTabOpenClose(
                      index: 1,
                      text: 'close_cash_tray'.tr,
                      onTapFunc: () {
                        // cont.setSelectedTabIndex(1);
                        usdAmount.text = '0';
                        anotherCurrencyAmount.text = '0';
                        usdNonCashAmount.text = '0';
                        anotherCurrencyNonCashAmount.text = '0';
                      },
                    ),
                  ],
                ),
                gapH10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:homeController.isMobile.value
                          ? CrossAxisAlignment.start
                      :CrossAxisAlignment.center,
                      children: [
                        Text(
                          cont.selectedTabIndex == 0
                              ? 'initialize_amount'.tr.toUpperCase()
                              : 'cash'.tr.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        gapH10,
                        Row(
                          children: [
                            ReusableInputNumberField(
                              controller: usdAmount,
                              text: '',
                              rowWidth: rowWidth,
                              textFieldWidth: rowWidth,
                              onChangedFunc: (value) {},
                              validationFunc: (val) {
                                if (val.isEmpty) {
                                  return 'required_field'.tr;
                                }
                                return null;
                              },
                            ),
                            gapW4,
                            Text(
                              productController.primaryCurrency,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        gapH10,
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? SizedBox()
                            : Row(
                              children: [
                                ReusableInputNumberField(
                                  controller: anotherCurrencyAmount,
                                  text: '',
                                  rowWidth: rowWidth,
                                  textFieldWidth: rowWidth,
                                  onChangedFunc: (value) {},
                                  validationFunc: (val) {},
                                ),
                                gapW4,
                                Text(
                                  productController.posCurrency,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                    cont.selectedTabIndex == 1 && !homeController.isMobile.value
                        ? Column(
                          children: [
                            Text(
                              'non_cash'.tr.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            gapH10,
                            Row(
                              children: [
                                ReusableInputNumberField(
                                  controller: usdNonCashAmount,
                                  text: '',
                                  rowWidth: rowWidth,
                                  textFieldWidth: rowWidth,
                                  onChangedFunc: (value) {},
                                  validationFunc: (val) {
                                    if (val.isEmpty) {
                                      return 'required_field'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                gapW4,
                                Text(
                                  productController.primaryCurrency,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            gapH10,
                            productController.primaryCurrency ==
                                    productController.posCurrency
                                ? SizedBox()
                                : Row(
                                  children: [
                                    ReusableInputNumberField(
                                      controller: anotherCurrencyNonCashAmount,
                                      text: '',
                                      rowWidth: rowWidth,
                                      textFieldWidth: rowWidth,
                                      onChangedFunc: (value) {},
                                      validationFunc: (val) {},
                                    ),
                                    gapW4,
                                    Text(
                                      productController.posCurrency,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                          ],
                        )
                        : const SizedBox(),
                  ],
                ),
                cont.selectedTabIndex == 1 && homeController.isMobile.value
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'non_cash'.tr.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    gapH10,
                    Row(
                      children: [
                        ReusableInputNumberField(
                          controller: usdNonCashAmount,
                          text: '',
                          rowWidth: rowWidth,
                          textFieldWidth: rowWidth,
                          onChangedFunc: (value) {},
                          validationFunc: (val) {
                            if (val.isEmpty) {
                              return 'required_field'.tr;
                            }
                            return null;
                          },
                        ),
                        gapW4,
                        Text(
                          productController.primaryCurrency,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    gapH10,
                    productController.primaryCurrency ==
                        productController.posCurrency
                        ? SizedBox()
                        : Row(
                      children: [
                        ReusableInputNumberField(
                          controller: anotherCurrencyNonCashAmount,
                          text: '',
                          rowWidth: rowWidth,
                          textFieldWidth: rowWidth,
                          onChangedFunc: (value) {},
                          validationFunc: (val) {},
                        ),
                        gapW4,
                        Text(
                          productController.posCurrency,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : const SizedBox(),
                gapH32,
                !homeController.isSessionToday && cont.selectedTabIndex == 0?
                Tooltip(
                  message: homeController.isSessionToday?'':'You can\'t open a new cash tray before closing this session and opening a new one.',
                  child: Container(
                    // padding: EdgeInsets.all(5),
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Primary.primary,
                      border: Border.all(
                        color: Primary.p0,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        'open_cash_tray'.tr,
                        style: TextStyle(fontSize: 14, color: Primary.p0),
                      ),
                    ),
                  ),
                )
                :ReusableButtonWithColor(
                  btnText:
                      cont.selectedTabIndex == 0
                          ? 'open_cash_tray'.tr
                          : 'close_cash_tray'.tr,
                  onTapFunction: () async {
                    if (_formKey.currentState!.validate()) {
                      if (cont.selectedTabIndex == 0) {
                        var currentSessionId = '';
                        var p = await getOpenSessionId();
                        if ('${p['data']}' != '[]') {
                          currentSessionId = '${p['data']['session']['id']}';
                        }
                        var res = await openCashTray(
                          currentSessionId,
                          usdAmount.text,
                          anotherCurrencyAmount.text,
                        );
                        if (res['success'] == true) {
                          Get.back();
                          Get.back();
                          Get.back();
                          Get.back();
                          productController.setIsCashAvailable(true);
                          CommonWidgets.snackBar('Success', res['message']);
                          // await saveCurrentOpenSessionIdInfoLocally(
                          //     '${res['data']['id']}');
                          // ignore: use_build_context_synchronously
                        } else {
                          CommonWidgets.snackBar(
                            'error',
                            res['message'] ?? 'error'.tr,
                          );
                        }
                      } else
                      { if( cashTrayNumberForClose.isNotEmpty){

                        showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => const AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                            ),
                            elevation: 0,
                            content: LoadingDialog(),
                          ),
                        );
                        var currentCashTrayId = '';
                        var currentSessionId = '';
                        var res1 = await getOpenSessionId();
                        if ('${res1['data']}' != '[]') {
                          currentSessionId = '${res1['data']['session']['id']}';
                        }

                        var userId = await getIdFromPref();
                        var p = await getOpenCashTrayId(
                          currentSessionId,
                          userId,
                        );

                        if ('$p' != '[]') {
                          // setState(() {
                          currentCashTrayId = '${p['id']}';
                          // });
                        }

                        var res = await closeCashTray(
                          currentCashTrayId,
                          usdAmount.text,
                          anotherCurrencyAmount.text,
                          usdNonCashAmount.text,
                          anotherCurrencyNonCashAmount.text,
                        );
                        Get.back();
                        if (res['success'] == true) {
                          // Get.back();
                          // CommonWidgets.snackBar(
                          //     'Success', res['message']);
                          //todo
                          productController.setIsCashAvailable(false);
                          var repoRes = await cont.getCashTrayReportFromBack(
                            '${res['data']['id']}',
                          );
                          if (repoRes['success'] == true) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const CashTraysReport();
                                },
                              ),
                            );
                          } else {
                            CommonWidgets.snackBar('error', repoRes['message']);
                          }
                        } else {
                          CommonWidgets.snackBar(
                            'error',
                            res['message'] ?? 'error'.tr,
                          );
                        }
                      }}
                    }
                  },
                  width: 150,
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReusableTabOpenClose extends StatefulWidget {
  const ReusableTabOpenClose({
    super.key,
    required this.text,
    required this.index,
    required this.onTapFunc,
  });
  final String text;
  final int index;
  final Function onTapFunc;
  @override
  State<ReusableTabOpenClose> createState() => _ReusableTabOpenCloseState();
}

class _ReusableTabOpenCloseState extends State<ReusableTabOpenClose> {
  HomeController homeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashTraysController>(
      builder: (cont) {
        return InkWell(
          onTap: () {
            widget.onTapFunc();
            cont.setSelectedTabIndex(widget.index);
          },
          child: Container(
            width:homeController.isMobile.value? MediaQuery.of(context).size.width * 0.3:MediaQuery.of(context).size.width * 0.34,
            height: 45,
            // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
              color:
                  cont.selectedTabIndex == widget.index
                      ? Primary.primary
                      : Primary.p20,
              border: Border(top: BorderSide(color: Primary.primary, width: 3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      cont.selectedTabIndex == widget.index
                          ? Colors.white
                          : Primary.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
