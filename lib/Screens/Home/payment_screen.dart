import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/orders/finish_order.dart';
import 'package:pos_project/Backend/orders/update_order.dart';
import '../../Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Backend/orders/add_order.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/PaymentMethodsWidget/payment_method_cards.dart';
import '../../Widgets/PaymentMethodsWidget/reusable_currency_card.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading_dialog.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../../const/constants.dart';
import '../../const/functions.dart';
import 'home_content.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController fieldController = TextEditingController();
  TextEditingController authCodeForMasterController = TextEditingController();
  TextEditingController authCodeForVisaController = TextEditingController();

  ClientController clientController = Get.find();
  PaymentController paymentController = Get.find();
  ProductController productController = Get.find();
  HomeController homeController = Get.find();
  OrdersController ordersController = Get.find();
  @override
  void initState() {
    authCodeForMasterController.clear();
    authCodeForVisaController.clear();
    paymentController.isOnAccountSelected = false;
    paymentController.invoiceNumber = '0';
    paymentController.selectedCashingMethodsList = [];
    paymentController.clickedPaymentMethodeId = '1';
    paymentController.clickedPaymentMethodeIndex = 1;
    paymentController.primaryCurrencyRemaining = 0.0;
    paymentController.primaryCurrencyChange = 0.0;
    paymentController.remainingWithExchange = 0.0;
    paymentController.changeWithExchange = 0.0;
    // paymentController.paymentCurrency = 'USD';
    paymentController.enteredValue = paymentController.paymentCurrency == productController.primaryCurrency
        ? '${productController.totalPriceWithExchange}'
        : '${productController.totalPrice}';
    // paymentController.selectedCustomerId = '-1';
    // paymentController.selectedCustomerIdWithOk = '-1';
    // paymentController.selectedCustomerObject = {};
    paymentController.setEnteredValue(paymentController.paymentCurrency == productController.primaryCurrency
        ? productController.totalPriceWithExchange.toStringAsFixed(2)
        : '${productController.totalPrice}');
    paymentController
        .setRemainingValue(productController.totalPriceWithExchange);
    var firstActiveMethod = paymentController.paymentMethodList.firstWhere(
        (m) => '${m['active']}' == "1" && '${m['title']}' == "Cash");

    paymentController.setClickedPaymentMethodeId('${firstActiveMethod['id']}');
    var ind=paymentController.paymentMethodList.indexOf(firstActiveMethod);
    paymentController.setClickedPaymentMethodeIndex(ind);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (cont) {
      return SizedBox(
        height: Sizes.deviceHeight * 0.95,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: Sizes.deviceHeight * 0.08,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Others.divider,
                ),
                bottom: BorderSide(
                  color: Others.divider,
                ),
              )),
              child: Center(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'payment'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    ),
                    homeController.isSessionToday? ReusableBackBtn(
                        title: 'back',
                        func: () {
                          // Get.delete<ProductController>(force: true);
                          // Get.delete<PaymentController>(force: true);
                          // Get.put(ProductController());
                          // Get.put(PaymentController());
                          homeController.setSelectedTab('Home');

                        }):SizedBox(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Sizes.deviceHeight * 0.87,
              child: Row(
                children: [
                  //payment method
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: Sizes.deviceHeight * 0.05,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        color: Others.divider, width: 3),
                                  )),
                                  child: Row(
                                    children: [
                                      Text(
                                        '    ${'payment_method'.tr}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Sizes.deviceHeight * 0.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cont.paymentMethodList.length,
                                    itemBuilder: (context, index) =>
                                        '${cont.paymentMethodList[index]['active']}' ==
                                                '1'
                                            ? '${cont.paymentMethodList[index]['title']}' ==
                                                        'On Account' &&
                                            clientController.selectedCustomerIdWithOk !=
                                                        '-1'
                                                ? PaymentMethodeCard(
                                                    onTapFunction: () {
                                                      cont.setClickedPaymentMethodeId(
                                                          '${cont.paymentMethodList[index]['id']}');
                                                      cont.setClickedPaymentMethodeIndex(
                                                          index);
                                                      cont.setIsClickedPaymentMethodeVisaOrMaster(false);
                                                    },
                                                    methodInfo:
                                                        cont.paymentMethodList[
                                                            index],
                                                  )
                                                : '${cont.paymentMethodList[index]['title']}' !=
                                                        'On Account'
                                                    ? PaymentMethodeCard(
                                                        onTapFunction: () {
                                                          cont.setClickedPaymentMethodeId(
                                                              '${cont.paymentMethodList[index]['id']}');
                                                          cont.setClickedPaymentMethodeIndex(
                                                              index);
                                                          if ('${cont.paymentMethodList[index]['title']}' == 'Master') {
                                                            cont.setIsClickedPaymentMethodeMaster(true);
                                                          }else if ('${cont.paymentMethodList[index]['title']}' == 'Visa') {
                                                            cont.setIsClickedPaymentMethodeVisa(true);
                                                          }else{
                                                            cont.setIsClickedPaymentMethodeVisaOrMaster(false);
                                                          }
                                                        },
                                                        methodInfo:
                                                            cont.paymentMethodList[
                                                                index],
                                                      )
                                                    : const SizedBox()
                                            : const SizedBox(),
                                  ),
                                ),
                                cont.isClickedPaymentMethodeVisa
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ReusableDialogTextField(
                                          textEditingController:
                                              authCodeForVisaController,
                                          text: 'auth'.tr,
                                          rowWidth: Sizes.deviceWidth*0.25,
                                          textFieldWidth: Sizes.deviceWidth*0.2,
                                          validationFunc: (val) {},
                                        ),
                                    )
                                    :const SizedBox(),
                                cont.isClickedPaymentMethodeMaster
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ReusableDialogTextField(
                                          textEditingController:
                                              authCodeForMasterController,
                                          text: 'auth'.tr,
                                          rowWidth: Sizes.deviceWidth*0.25,
                                          textFieldWidth: Sizes.deviceWidth*0.2,
                                          validationFunc: (val) {},
                                        ),
                                    )
                                    :const SizedBox(),
                                Container(
                                  height: Sizes.deviceHeight * 0.05,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        color: Others.divider, width: 3),
                                  )),
                                  child: Row(
                                    children: [
                                      Text(
                                        '    ${'summary'.tr}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Sizes.deviceHeight * 0.4,
                                  child: ListView.builder(
                                      itemCount: cont
                                          .selectedCashingMethodsList.length,
                                      itemBuilder: (context, index) {
                                        // var keys =
                                        //     cont.selectedMethodsList.keys.toList();
                                        return SelectedPaymentMethodeCard(
                                            onTapFunction: () {
                                              cont.setClickedPaymentMethodeId(
                                                  '${cont.selectedCashingMethodsList[index]['id']}');
                                            },
                                            onRemoveFunction: () {
                                              if (cont.selectedCashingMethodsList[
                                                      index]['title'] ==
                                                  'On Account') {
                                                cont.setIsOnAccountSelected(
                                                    false);
                                              }
                                              cont.removeFromSelectedMethodsList(
                                                  cont.selectedCashingMethodsList[
                                                      index]);
                                              // cont.removeFromSelectedMethodsList(
                                              //     '${cont.selectedMethodsList[keys[index]]['id']}');
                                            },
                                            methodInfo:
                                                cont.selectedCashingMethodsList[
                                                    index]
                                            // cont.selectedMethodsList[keys[index]],
                                            );
                                      }),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: (cont.primaryCurrencyRemaining.toStringAsFixed(2) =='0.00' &&
                                        cont.selectedCashingMethodsList
                                            .isNotEmpty) ||
                                clientController.selectedCustomerIdWithOk != '-1' ||
                                    productController.totalPrice.toStringAsFixed(2) == '0.00'
                                ? () async {
                                    {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(9)),
                                                  ),
                                                  elevation: 0,
                                                  content: LoadingDialog()));
                                      var currentSessionId = '';
                                      var res = await getOpenSessionId();
                                      if ('${res['data']}' != '[]') {
                                        currentSessionId =
                                            '${res['data']['session']['id']}';
                                      }
                                      var roleName =
                                          await getRoleNameFromPref();
                                      var userId = await getIdFromPref();
                                      var cashTrayId = '';
                                      var cashTrayRes = await getOpenCashTrayId(
                                          currentSessionId, userId);
                                      if ('$cashTrayRes' != '[]') {
                                        cashTrayId = '${cashTrayRes['id']}';
                                      }
                                      double usdRemainingOnAccount = 0,
                                          remainingWithExchangeOnAccount = 0;
                                      if (cont.isOnAccountSelected) {
                                        if (cont.selectedCashingMethodsList[cont
                                                .onAccountIndex]['currency'] ==
                                            productController.primaryCurrency) {
                                          usdRemainingOnAccount = double.parse(
                                              cont.selectedCashingMethodsList[
                                                      cont.onAccountIndex]
                                                  ['price']);
                                          remainingWithExchangeOnAccount =
                                              usdRemainingOnAccount *
                                                  double.parse(
                                                      '${productController.latestRate}');
                                        } else {
                                          remainingWithExchangeOnAccount =
                                              double.parse(
                                                  cont.selectedCashingMethodsList[
                                                          cont.onAccountIndex]
                                                      ['price']);
                                          usdRemainingOnAccount =
                                              remainingWithExchangeOnAccount /
                                                  double.parse(
                                                      '${productController.latestRate}');
                                        }
                                      }
                                      if (!productController
                                          .isRetrieveOrderSelected) {
                                        var parkRes = await addOrder(
                                            productController.orderItemsList,
                                          productController.taxesSum
                                              .toStringAsFixed(2),
                                            productController
                                                    .orderItemsList.isNotEmpty
                                                ? '${productController.totalDiscountWithExchange}'
                                                : '0',
                                          productController.taxesSumWithExchange.toStringAsFixed(2),
                                            productController
                                                    .orderItemsList.isNotEmpty
                                                ? '${productController.totalDiscount}'
                                                : '0',
                                            productController
                                                .totalPriceWithExchange
                                                .toStringAsFixed(2),
                                            productController.totalPrice
                                                .toStringAsFixed(2),
                                            productController
                                                        .selectedDiscountTypeId ==
                                                    '0'
                                                ? ''
                                                : productController
                                                    .selectedDiscountTypeId,
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
                                        // Get.back();
                                        if (parkRes != 'error') {
                                          ordersController.setSelectedOrderId(
                                              '${parkRes['id']}');
                                          var p = await finishOrder(
                                              roleName,
                                              cashTrayId,
                                              ordersController.selectedOrderId,
                                              paymentController
                                                  .selectedCashingMethodsList,
                                              paymentController.primaryCurrencyChange
                                                  .toStringAsFixed(2),
                                              paymentController
                                                  .changeWithExchange
                                                  .toStringAsFixed(2),
                                              cont.isOnAccountSelected
                                                  ? usdRemainingOnAccount
                                                      .toStringAsFixed(2)
                                                  : paymentController
                                                      .primaryCurrencyRemaining
                                                      .toStringAsFixed(2),
                                              cont.isOnAccountSelected
                                                  ? remainingWithExchangeOnAccount
                                                      .toStringAsFixed(2)
                                                  : paymentController
                                                      .remainingWithExchange
                                                      .toStringAsFixed(2),
                                              clientController
                                                          .selectedCustomerIdWithOk ==
                                                      '-1'
                                                  ? ''
                                                  : clientController
                                                      .selectedCustomerIdWithOk,
                                              currentSessionId,
                                              clientController.selectedCarId
                                          );
                                          Get.back();
                                          if (p['success'] == true) {
                                            Get.back();
                                            cont.setInvoiceNumber(
                                                p['data']['orderNumber']);
                                            homeController
                                                .setSelectedTab('print');
                                          } else {
                                            Get.back();
                                            CommonWidgets.snackBar(
                                                'error', p['message']);
                                          }
                                        } else {
                                          CommonWidgets.snackBar(
                                              'error', 'error'.tr);
                                        }
                                      }
                                      else {
                                        var updateRes = await updateOrder(
                                            productController.orderItemsList,
                                            ordersController.selectedOrderId,
                                            productController.taxesSum
                                                .toStringAsFixed(2),
                                            productController
                                                    .orderItemsList.isNotEmpty
                                                ? '${productController.totalDiscountWithExchange}'
                                                : '0',
                                            productController
                                                .taxesSumWithExchange
                                                .toStringAsFixed(2),
                                            productController
                                                    .orderItemsList.isNotEmpty
                                                ? '${productController.totalDiscount}'
                                                : '0',
                                            productController
                                                .totalPriceWithExchange
                                                .toStringAsFixed(2),
                                            productController.totalPrice
                                                .toStringAsFixed(2),
                                            productController
                                                        .selectedDiscountTypeId ==
                                                    '0'
                                                ? ''
                                                : productController
                                                    .selectedDiscountTypeId,
                                            currentSessionId,
                                            noteController.text);
                                        if (updateRes != 'error') {
                                          var p = await finishOrder(
                                              roleName,
                                              cashTrayId,
                                              ordersController.selectedOrderId,
                                              paymentController
                                                  .selectedCashingMethodsList,
                                              paymentController.primaryCurrencyChange
                                                  .toStringAsFixed(2),
                                              paymentController
                                                  .changeWithExchange
                                                  .toStringAsFixed(2),
                                              cont.isOnAccountSelected
                                                  ? usdRemainingOnAccount
                                                      .toStringAsFixed(2)
                                                  : paymentController
                                                      .primaryCurrencyRemaining
                                                      .toStringAsFixed(2),
                                              cont.isOnAccountSelected
                                                  ? remainingWithExchangeOnAccount
                                                      .toStringAsFixed(2)
                                                  : paymentController
                                                      .remainingWithExchange
                                                      .toStringAsFixed(2),
                                              clientController
                                                          .selectedCustomerIdWithOk ==
                                                      '-1'
                                                  ? ''
                                                  : clientController
                                                      .selectedCustomerIdWithOk,
                                              currentSessionId,
                                              clientController.selectedCarId);
                                          Get.back();
                                          if (p['success'] == true) {
                                            Get.back();
                                            cont.setInvoiceNumber(
                                                p['data']['orderNumber']);
                                            homeController
                                                .setSelectedTab('print');
                                          } else {
                                            Get.back();
                                            CommonWidgets.snackBar(
                                                'error', p['message']);
                                          }
                                        }
                                      }
                                    }
                                    //
                                    // var p = await sendOrder(
                                    //   productController.orderItemsList,
                                    //   paymentController.selectedCashingMethodsList,
                                    //   // paymentController.selectedMethodsList,
                                    //   '${productController.taxesSumWithExchange}',
                                    //   productController
                                    //           .orderItemsList.isNotEmpty
                                    //       ? '${productController.totalDiscountWithExchange}'
                                    //       : '0',
                                    //   productController.taxesSum.toStringAsFixed(2),
                                    //   productController
                                    //           .orderItemsList.isNotEmpty
                                    //       ? '${productController.totalDiscount}'
                                    //       : '0',
                                    //   productController.totalPriceWithExchange.toStringAsFixed(2),
                                    //   productController.totalPrice.toStringAsFixed(2),
                                    //   productController
                                    //               .selectedDiscountTypeId ==
                                    //           '0'
                                    //       ? ''
                                    //       : productController
                                    //           .selectedDiscountTypeId,
                                    //   paymentController.usdChange.toStringAsFixed(2),
                                    //   paymentController.changeWithExchange.toStringAsFixed(2),
                                    //   paymentController.usdRemaining.toStringAsFixed(2),
                                    //   paymentController.remainingWithExchange.toStringAsFixed(2),
                                    //   paymentController.selectedCustomerIdWithOk =='-1'?'':paymentController.selectedCustomerIdWithOk
                                    // );
                                  }
                                : null,
                            child: Container(
                              height: homeController.isTablet
                                  ? Sizes.deviceHeight * 0.1
                                  : Sizes.deviceHeight * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: (cont.primaryCurrencyRemaining.toStringAsFixed(2) == '0.00' &&
                                            cont.selectedCashingMethodsList
                                                .isNotEmpty) ||
                                    clientController.selectedCustomerIdWithOk != '-1' ||
                                        productController.totalPrice.toStringAsFixed(2) == '0.00'
                                // || cont.selectedCustomerIdWithOk != '-1'
                                    ? Primary.primary
                                    : Primary.primary.withAlpha((0.7 * 255).toInt()),
                              ),
                              child: Center(
                                  child: Text(
                                'validate'.tr,
                                style:
                                    TextStyle(fontSize: 14, color: Primary.p0),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Others.divider, width: 3)),
                        child: Column(
                          children: [
                            Container(
                              height: Sizes.deviceHeight * 0.2,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: cont.selectedCashingMethodsList.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${productController.posCurrency} ${numberWithComma(productController.totalPrice.toStringAsFixed(2))} \n'
                                          '${productController.primaryCurrency} ${numberWithComma(productController.totalPriceWithExchange.toStringAsFixed(2))}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Primary.primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        gapH6,
                                        Text('select_method'.tr)
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(''),
                                                Text('invoice_total'.tr,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Primary.primary)),
                                                Text('change'.tr,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Primary.primary)),
                                                Text('remaining'.tr,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Primary.primary)),
                                              ],
                                            ),
                                            gapW20,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productController
                                                      .posCurrency,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Primary.primary,
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  numberWithComma(
                                                      productController
                                                          .totalPrice
                                                          .toStringAsFixed(2)),
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  numberWithComma(cont
                                                      .changeWithExchange
                                                      .toStringAsFixed(2)),
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  numberWithComma(cont
                                                      .remainingWithExchange
                                                      .toStringAsFixed(2)),
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        productController.primaryCurrency==productController.posCurrency?SizedBox():Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productController
                                                  .primaryCurrency,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Primary.primary,
                                                  fontSize: 17),
                                            ),
                                            Text(
                                              numberWithComma(productController
                                                  .totalPriceWithExchange
                                                  .toStringAsFixed(2)),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                            Text(
                                              numberWithComma(cont.primaryCurrencyChange
                                                  .toStringAsFixed(2)),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                            Text(
                                              numberWithComma(cont.primaryCurrencyRemaining
                                                  .toStringAsFixed(2)),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                            Expanded(
                                child: Divider(
                              color: Others.divider,
                              thickness: 3,
                            )),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: Sizes.deviceHeight * 0.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ReusableCurrencyCard(
                                        onTapFunction: () {
                                          setState(() {
                                            cont.setPaymentCurrency(
                                                productController
                                                    .primaryCurrency);
                                            cont.setEnteredValue(cont
                                                .enteredValue = double.parse(
                                                    ('${double.parse(cont.enteredValue) / double.parse('${productController.latestRate}')}'))
                                                .toStringAsFixed(2));
                                          });
                                        },
                                        text:
                                            productController.primaryCurrency,
                                      ),
                                      gapW10,
                                      productController.primaryCurrency==productController.posCurrency?SizedBox():ReusableCurrencyCard(
                                        onTapFunction: () {
                                          setState(() {
                                            cont.setPaymentCurrency(
                                                productController
                                                    .posCurrency);
                                            cont.setEnteredValue(cont
                                                .enteredValue = double.parse(
                                                    '${double.parse(cont.enteredValue) * double.parse('${productController.latestRate}')}')
                                                .toStringAsFixed(2));
                                          });
                                        },
                                        text:
                                            productController.posCurrency,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: Sizes.deviceWidth * 0.15,
                                    height: Sizes.deviceHeight * 0.09,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Others.divider, width: 3),
                                        borderRadius: BorderRadius.circular(0)),
                                    child: Center(
                                        child: Text(
                                      cont.paymentCurrency == productController.primaryCurrency
                                          ? numberWithComma(
                                              double.parse(cont.enteredValue)
                                                  .toStringAsFixed(2))
                                          : numberWithComma(
                                              double.parse(cont.enteredValue)
                                                  .toStringAsFixed(2)),
                                      style: const TextStyle(fontSize: 17),
                                    )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Sizes.deviceHeight * 0.55,
                              child: GridView.count(
                                crossAxisCount: 4, // 3,
                                childAspectRatio: (Sizes.deviceWidth *
                                        0.6 /
                                        Sizes.deviceHeight *
                                        1.28
                                    //1.72
                                    ),
                                children: List.generate(
                                    calculatorNumbers.length, (index) {
                                  return ReusableCalculatorBtn(
                                      onTapFunction: () {
                                        // print('cont.enteredValue');
                                        // print(cont.enteredValue);
                                        // print('cont.primaryCurrencyRemaining');
                                        // print(cont.primaryCurrencyRemaining);
                                        if (calculatorNumbers[index] == '.' &&
                                            (cont.enteredValue.contains('.') ||
                                                cont.paymentCurrency !=
                                                    productController.primaryCurrency)) {
                                          //todo nothing or show message
                                        } else if (calculatorNumbers[index] ==
                                                'C' &&
                                            cont.enteredValue == '0.00') {
                                        } else if ((double.parse(cont.enteredValue).toStringAsFixed(2) ==
                                                    '0.00' ||
                                                cont.enteredValue == '0') &&
                                            [
                                              '1',
                                              '2',
                                              '3',
                                              '4',
                                              '5',
                                              '6',
                                              '7',
                                              '8',
                                              '9',
                                              '0'
                                            ].contains(
                                                calculatorNumbers[index])) {
                                          cont.setEnteredValue(
                                              calculatorNumbers[index]);
                                        } else if (cont.paymentCurrency ==
                                            productController.primaryCurrency &&
                                            (cont.enteredValue == '0' || double.parse(cont.enteredValue).toStringAsFixed(2) ==
                                                '0.00' ) &&
                                            calculatorNumbers[index] == '.') {
                                          cont.setEnteredValue('0.');
                                        } else if ((double.parse(cont.enteredValue).toStringAsFixed(2) ==
                                            '0.00' ||
                                                cont.enteredValue == '0') &&
                                            (calculatorNumbers[index] == '⌫' ||
                                                calculatorNumbers[index] ==
                                                    '.' ||
                                                calculatorNumbers[index] ==
                                                    'add'.tr ||
                                                calculatorNumbers[index] ==
                                                    'C' ||
                                                // calculatorNumbers[index] ==
                                                //     '0' ||
                                                calculatorNumbers[index] ==
                                                    '00' ||
                                                calculatorNumbers[index] ==
                                                    '000')) {
                                          //todo nothing or show message
                                        } else {
                                          if (calculatorNumbers[index] == '⌫') {
                                            if (cont.enteredValue.length == 1) {
                                              cont.setEnteredValue('0.00');
                                            } else {
                                              String txt = cont.enteredValue
                                                  .substring(
                                                      0,
                                                      cont.enteredValue.length -
                                                          1);

                                              cont.setEnteredValue(txt);
                                            }
                                          } else if (calculatorNumbers[index] ==
                                              'add'.tr) {
                                            if (double.parse(cont.enteredValue).toStringAsFixed(2) !=
                                                '0.00' ) {
                                              var currency =
                                                  cont.paymentCurrency;
                                              // cont.setClickedPaymentMethodeId(
                                              //     '${cont.paymentMethodList[index]['id']}');
                                              if (cont.paymentMethodList[cont
                                                          .clickedPaymentMethodeIndex]
                                                      ['title'] == 'On Account') {
                                                if (cont.isOnAccountSelected ==
                                                    false) {
                                                  Map method = {
                                                    'id': cont.clickedPaymentMethodeId,
                                                    'title': cont
                                                                .paymentMethodList[
                                                            cont.clickedPaymentMethodeIndex]
                                                        ['title'],
                                                    'active': cont
                                                                .paymentMethodList[
                                                            cont.clickedPaymentMethodeIndex]
                                                        ['active'],
                                                    'price': double.parse(cont.enteredValue).toStringAsFixed(2),
                                                    'currency': currency,
                                                    'authCode ':''
                                                  };
                                                  cont.setIsOnAccountSelected(
                                                      true);
                                                  int index = cont
                                                      .selectedCashingMethodsList
                                                      .length;
                                                  paymentController
                                                      .addToSelectedMethodsList(
                                                          method);
                                                  cont.setOnAccountIndex(index);
                                                } else {
                                                  cont.setPriceAndCurrencyOnAccount(
                                                    double.parse(cont.enteredValue).toStringAsFixed(2),
                                                      currency,
                                                  );
                                                  // cont.selectedCashingMethodsList[index]['price']=cont.enteredValue;
                                                  // cont.selectedCashingMethodsList[index]['currency']=currency;
                                                }
                                              } else {
                                                Map method = {
                                                  'id': cont
                                                      .clickedPaymentMethodeId,
                                                  'title': cont
                                                              .paymentMethodList[
                                                          cont.clickedPaymentMethodeIndex]
                                                      ['title'],
                                                  'active': cont
                                                              .paymentMethodList[
                                                          cont.clickedPaymentMethodeIndex]
                                                      ['active'],
                                                  'price': double.parse(cont.enteredValue).toStringAsFixed(2),
                                                  'currency': currency,
                                                  'authCode':cont.paymentMethodList[cont
                                                      .clickedPaymentMethodeIndex]
                                                  ['title'] == 'Master'?authCodeForMasterController.text:authCodeForVisaController.text
                                                };
                                                paymentController
                                                    .addToSelectedMethodsList(
                                                        method);
                                              }
                                              cont.calculateRemAndChange();
                                              cont.setEnteredValue(paymentController
                                                          .paymentCurrency ==
                                                  productController.primaryCurrency
                                                  ? '${paymentController.primaryCurrencyRemaining}'
                                                  : '${paymentController.remainingWithExchange}');
                                            }
                                          } else if (calculatorNumbers[index] ==
                                              'C') {
                                            cont.setEnteredValue('0.00');
                                          } else {
                                            // if (cont.clickedPaymentMethodeId!='-1')
                                            setState(() {
                                              String val;
                                              if (double.parse(cont.enteredValue).toStringAsFixed(2) == '0.00' ||
                                                  double.parse(cont.enteredValue).toStringAsFixed(2) == '0' ||
                                                  double.parse(cont.enteredValue).toStringAsFixed(2) ==
                                                      productController.totalPriceWithExchange.toStringAsFixed(2) ||
                                                  double.parse(cont.enteredValue).toStringAsFixed(2) ==
                                                      productController.totalPrice.toStringAsFixed(2)) {
                                                val = calculatorNumbers[index];
                                                // cont.calculateRemAndChange();
                                              } else {
                                                val = cont.enteredValue +
                                                    calculatorNumbers[index];
                                              }
                                              cont.setEnteredValue(val);
                                              // cont.calculateRemAndChange();
                                            });
                                          }
                                          // else {
                                          //   if (cont.enteredValue == '0.0') {
                                          //     cont.setEnteredValue(
                                          //         calculatorNumbers[index]);
                                          //   } else {
                                          //     String txt = cont.enteredValue +
                                          //         calculatorNumbers[index];
                                          //     cont.setEnteredValue(txt);
                                          //   }
                                          // }
                                        }
                                      },
                                      //     () {
                                      //   if( calculatorNumbers[index] ==
                                      //       '.' && cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'].contains('.')){
                                      //       //todo nothing or show message
                                      //   }
                                      //   if ((cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'] == '0.00'
                                      //       || cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'] ==
                                      //       productController.totalPriceWithExchange.toStringAsFixed(3)
                                      //       || cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'] ==
                                      //       productController.totalPrice.toStringAsFixed(3)
                                      //   ) &&
                                      //       (
                                      //           calculatorNumbers[index] == '⌫' ||
                                      //           calculatorNumbers[index] ==
                                      //               '.' ||
                                      //           calculatorNumbers[index] ==
                                      //               'apply'.tr ||
                                      //           calculatorNumbers[index] ==
                                      //               'clear'.tr ||
                                      //           calculatorNumbers[index] ==
                                      //               '0' ||
                                      //           calculatorNumbers[index] ==
                                      //               '00' ||
                                      //           calculatorNumbers[index] ==
                                      //               '000')) {
                                      //     //todo nothing or show message
                                      //   } else {
                                      //     if (calculatorNumbers[index] == '⌫') {
                                      //       if(cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'].length==1){
                                      //          setState(() {
                                      //            cont.setPriceInCashMethod(
                                      //                cont.clickedPaymentMethodeId,
                                      //                '0.00');
                                      //          });
                                      //       }else{
                                      //         String txt =cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'].substring(
                                      //             0,
                                      //             cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'].length - 1);
                                      //      setState(() {
                                      //        cont.setPriceInCashMethod(
                                      //            cont.clickedPaymentMethodeId,
                                      //            txt);
                                      //      });
                                      //
                                      //       }
                                      //       // String txt = cont.enteredValue
                                      //       //     .substring(
                                      //       //         0,
                                      //       //         cont.enteredValue.length -
                                      //       //             1);
                                      //       // if (txt == '') {
                                      //       //   cont.setEnteredValue('0.0');
                                      //       // } else {
                                      //       //   cont.setEnteredValue(txt);
                                      //       // }
                                      //     } else {
                                      //       // if (calculatorNumbers[index] ==
                                      //       //   'apply'.tr) {
                                      //       if (cont.selectedMethodsList.isNotEmpty) {
                                      //           setState(() {
                                      //             String val;
                                      //             if (cont
                                      //                 .selectedMethodsList[cont
                                      //                 .clickedPaymentMethodeId]['price'] ==
                                      //                 '0.00'
                                      //             || cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'] ==
                                      //                     productController.totalPriceWithExchange.toStringAsFixed(3)
                                      //                 || cont.selectedMethodsList[cont.clickedPaymentMethodeId]['price'] ==
                                      //                     productController.totalPrice.toStringAsFixed(3)
                                      //             ) {
                                      //               val =
                                      //               calculatorNumbers[index];
                                      //               cont.calculateRemAndChange();
                                      //             } else {
                                      //               val = cont
                                      //                   .selectedMethodsList[cont
                                      //                   .clickedPaymentMethodeId]['price'] +
                                      //                   calculatorNumbers[index];
                                      //             }
                                      //             cont.setPriceInCashMethod(
                                      //                 cont
                                      //                     .clickedPaymentMethodeId,
                                      //                 val);
                                      //             cont.setCurrencyInCashMethod(
                                      //                 cont
                                      //                     .clickedPaymentMethodeId,
                                      //                 cont.paymentCurrency);
                                      //             cont.calculateRemAndChange();
                                      //           });
                                      //       }
                                      //     }
                                      //     // else if (calculatorNumbers[index] ==
                                      //     //     'clear'.tr) {
                                      //     //   cont.setEnteredValue('0.0');
                                      //     // } else {
                                      //     //   if (cont.enteredValue == '0.0') {
                                      //     //     cont.setEnteredValue(
                                      //     //         calculatorNumbers[index]);
                                      //     //   } else {
                                      //     //     String txt = cont.enteredValue +
                                      //     //         calculatorNumbers[index];
                                      //     //     cont.setEnteredValue(txt);
                                      //     //   }
                                      //     // }
                                      //   }
                                      // },
                                      text: calculatorNumbers[index]);
                                }),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container()
                          // ServicesCard(
                          //   onTapFunction: () {
                          //     showDialog<String>(
                          //         context: context,
                          //         builder: (BuildContext context) =>
                          //             const AlertDialog(
                          //               backgroundColor: Colors.white,
                          //               // contentPadding: EdgeInsets.all(0),
                          //               // titlePadding: EdgeInsets.all(0),
                          //               // actionsPadding: EdgeInsets.all(0),
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.all(
                          //                     Radius.circular(9)),
                          //               ),
                          //               elevation: 0,
                          //               content: CustomersDialog(),
                          //             ));
                          //   },
                          //   text: cont.selectedCustomerIdWithOk == '-1'
                          //       ? 'cash_customer'.tr
                          //       : cont.selectedCustomerObject['name'],
                          //   icon: Icons.person,
                          //   color: cont.selectedCustomerIdWithOk == '-1'
                          //       ? Colors.white
                          //       : Primary.primary,
                          //   textColor: cont.selectedCustomerIdWithOk == '-1'
                          //       ? Colors.black
                          //       : Colors.white,
                          // )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
//
// class PaymentMethodeCard extends StatefulWidget {
//   const PaymentMethodeCard(
//       {super.key, required this.onTapFunction, required this.methodInfo});
//   final Function onTapFunction;
//   final Map methodInfo;
//
//   @override
//   State<PaymentMethodeCard> createState() => _PaymentMethodeCardState();
// }
//
// class _PaymentMethodeCardState extends State<PaymentMethodeCard> {
//   bool isHovered = false;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<PaymentController>(builder: (cont) {
//       return InkWell(
//         onTap: () {
//           widget.onTapFunction();
//         },
//         // onHover: (val) {
//         //   if (val) {
//         //     setState(() {
//         //       isHovered = true;
//         //     });
//         //   } else {
//         //     setState(() {
//         //       isHovered = false;
//         //     });
//         //   }
//         // },
//         child: Column(
//           children: [
//             Container(
//               width: 100,
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//               decoration:
//                   //     ? BoxDecoration(
//                   //   borderRadius: BorderRadius.circular(0),
//                   //   color: Primary.primary.withAlpha((0.2 * 255).toInt()),
//                   //     border: Border(
//                   //             bottom: BorderSide(
//                   //               color: Others.divider,
//                   //             ),
//                   // ))
//                   //     :   BoxDecoration(
//                   //   border: Border(
//                   //           bottom: BorderSide(
//                   //             color: Others.divider,
//                   //           ),)
//                   // ),
//                   BoxDecoration(
//                       color: '${widget.methodInfo['id']}' ==
//                               cont.clickedPaymentMethodeId
//                           ? Primary.primary.withAlpha((0.2 * 255).toInt())
//                           : Colors.white,
//                       border: Border(
//                         bottom: BorderSide(
//                           color: Others.divider,
//                         ),
//                       )),
//               child: Center(child: Text(widget.methodInfo['title'])),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// class SelectedPaymentMethodeCard extends StatelessWidget {
//   const SelectedPaymentMethodeCard(
//       {super.key,
//       required this.onTapFunction,
//       required this.methodInfo,
//       required this.onRemoveFunction});
//   final Function onTapFunction;
//   final Function onRemoveFunction;
//   final Map methodInfo;
//   @override
//   Widget build(BuildContext context) {
//     ProductController productController=Get.find();
//     return GetBuilder<PaymentController>(builder: (cont) {
//       return InkWell(
//         // onTap: () {
//         //   onTapFunction();
//         // },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(0),
//               color: Colors.white,
//               border: Border(
//                 bottom: BorderSide(
//                   color: Others.divider,
//                 ),
//               )),
//           // : const BoxDecoration(),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(methodInfo['title']),
//               Row(
//                 children: [
//                   Text(methodInfo['currency'] == productController.primaryCurrency
//                       ? numberWithComma(
//                           double.parse(methodInfo['price']).toStringAsFixed(2))
//                       : numberWithComma(double.parse(methodInfo['price'])
//                           .toStringAsFixed(2))),
//                   // numberWithComma(cont.selectedMethodsList['${methodInfo['id']}']['price'])),
//                   Text(' ${methodInfo['currency']}'),
//                   gapW20,
//                   InkWell(
//                     onTap: () {
//                       onRemoveFunction();
//                       cont.calculateRemAndChange();
//                     },
//                     child: CircleAvatar(
//                       backgroundColor: Primary.primary,
//                       radius: 10,
//                       child: const Icon(
//                         Icons.close_rounded,
//                         color: Colors.white,
//                         size: 15,
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

class ServicesCard extends StatefulWidget {
  const ServicesCard(
      {super.key,
      required this.onTapFunction,
      required this.text,
      required this.icon,
      required this.color,
      required this.textColor});
  final Function onTapFunction;
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  @override
  State<ServicesCard> createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTapFunction();
      },
      onHover: (val) {
        if (val) {
          setState(() {
            isHovered = true;
          });
        } else {
          setState(() {
            isHovered = false;
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: widget.color,
                // isHovered ? Primary.primary.withAlpha((0.2 * 255).toInt()) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Others.divider,
                  ),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(widget.icon,
                    size: 25, color: widget.textColor // Colors.black87,
                    ),
                gapW8,
                Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: 16,
                      color: widget
                          .textColor //Colors.black87, fontWeight: FontWeight.bold
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ReusableCurrencyCard extends StatelessWidget {
//   const ReusableCurrencyCard(
//       {super.key, required this.onTapFunction, required this.text});
//   final Function onTapFunction;
//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<PaymentController>(builder: (cont) {
//       return InkWell(
//           onTap: () {
//             onTapFunction();
//           },
//           child: Container(
//             height: Sizes.deviceHeight * 0.09,
//             width: Sizes.deviceWidth * 0.06,
//             decoration: BoxDecoration(
//                 color: cont.paymentCurrency == text
//                     ? Primary.primary
//                     : Colors.white,
//                 border: Border.all(
//                   color: Others.divider,
//                 )),
//             child: Center(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                     color: cont.paymentCurrency == text
//                         ? Colors.white
//                         : Colors.black87),
//               ),
//             ),
//           ));
//     });
//   }
// }

class ReusableCalculatorBtn extends StatefulWidget {
  const ReusableCalculatorBtn(
      {super.key,
      required this.onTapFunction,
      required this.text,
      this.fontSize = 45,
      this.tabletFontSize = 42,
        this.isEnable=true});
  final Function onTapFunction;
  final String text;
  final double fontSize;
  final double tabletFontSize;
  final bool isEnable;
  @override
  State<ReusableCalculatorBtn> createState() => _ReusableCalculatorBtnState();
}

class _ReusableCalculatorBtnState extends State<ReusableCalculatorBtn> {
  bool isHovered = false;
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover:widget.isEnable? (val) {
        if (val) {
          setState(() {
            isHovered = true;
          });
        } else {
          setState(() {
            isHovered = false;
          });
        }
      }:null,
      onTap:widget.isEnable? () {
        widget.onTapFunction();
      }:null,
      child: Container(
        decoration: BoxDecoration(
            color: isHovered ? Primary.primary.withAlpha((0.2 * 255).toInt()) : Colors.white,
            border: Border.all(
              color: Others.divider,
            )),
        child: Center(
            child: Text(
          widget.text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: homeController.isTablet
                  ? widget.tabletFontSize
                  : widget.fontSize),
        )),
      ),
    );
  }
}
