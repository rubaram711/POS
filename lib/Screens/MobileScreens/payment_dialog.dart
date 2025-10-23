import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/client_controller.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/orders_controller.dart';
import 'package:pos_project/Controllers/payment_controller.dart';
import 'package:pos_project/Screens/MobileScreens/payment_success_screen.dart';
import 'package:pos_project/Widgets/reusable_text_field.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Backend/orders/add_order.dart';
import '../../Backend/orders/finish_order.dart';
import '../../Backend/orders/update_order.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/PaymentMethodsWidget/payment_method_cards.dart';
import '../../Widgets/PaymentMethodsWidget/reusable_currency_card.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/loading_dialog.dart';
import '../../const/functions.dart';
import '../../const/urls.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();
  HomeController homeController = Get.find();
  OrdersController ordersController = Get.find();
  ClientController clientController = Get.find();

  TextEditingController searchInCustomersController = TextEditingController();
  TextEditingController customerPaidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // authCodeForMasterController.clear();
    // authCodeForVisaController.clear();
    productController.selectedDiscountTypeId = '0';
    clientController.selectedCustomerIdWithOk = '-1';
    clientController.selectedCustomerObject = {};
    clientController.selectedCustomerId = '-1';
    searchInCustomersController.text = '';
    clientController.getAllClientsFromBack();
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
    paymentController.enteredValue =
        paymentController.paymentCurrency == productController.primaryCurrency
            ? productController.totalPriceWithExchange.toStringAsFixed(2)
            : '${productController.totalPrice}';
    // paymentController.selectedCustomerId = '-1';
    // paymentController.selectedCustomerIdWithOk = '-1';
    // paymentController.selectedCustomerObject = {};
    customerPaidController.text =
        paymentController.paymentCurrency == productController.primaryCurrency
            ? productController.totalPriceWithExchange.toStringAsFixed(2)
            : '${productController.totalPrice}';
    paymentController.setRemainingValue(
      productController.totalPriceWithExchange,
    );
    var firstActiveMethod = paymentController.paymentMethodList.firstWhere(
      (m) => '${m['active']}' == "1" && '${m['title']}' == "Cash",
    );
    paymentController.setClickedPaymentMethodeId('${firstActiveMethod['id']}');
    var ind = paymentController.paymentMethodList.indexOf(firstActiveMethod);
    paymentController.setClickedPaymentMethodeIndex(ind);
    paymentController.setSelectedCashMethodOption(2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      builder: (paymentCont) {
        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<ClientController>(
                        builder: (clientCont) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'customer'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              DropdownMenu<String>(
                                width: MediaQuery.of(context).size.width,
                                // requestFocusOnTap: false,
                                enableSearch: true,
                                controller: searchInCustomersController,
                                hintText: '${'search'.tr}...',
                                inputDecorationTheme: InputDecorationTheme(
                                  // filled: true,
                                  hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    25,
                                    5,
                                  ),
                                  // outlineBorder: BorderSide(color: Colors.black,),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Primary.primary.withAlpha(
                                        (0.2 * 255).toInt(),
                                      ),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Primary.primary.withAlpha(
                                        (0.4 * 255).toInt(),
                                      ),
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                  ),
                                ),
                                // menuStyle: ,
                                menuHeight: 250,
                                dropdownMenuEntries:
                                    clientCont.customersNamesList
                                        .map<DropdownMenuEntry<String>>((
                                          String option,
                                        ) {
                                          return DropdownMenuEntry<String>(
                                            value: option,
                                            label: option,
                                          );
                                        })
                                        .toList(),
                                enableFilter: true,
                                onSelected: (String? val) {
                                  var index = clientCont.customersNamesList
                                      .indexOf(val!);
                                  clientController.setSelectedCustomerId(
                                    clientCont.customersIdsList[index]
                                        .toString(),
                                  );
                                  clientController.setSelectedCustomerObject(
                                    clientCont.customersList[index],
                                  );
                                  productController.setTotalDiscountAsPercent(
                                    double.parse(
                                      '${clientCont.customersList[index]['grantedDiscount'] ?? clientCont.customersList[index]['granted_discount'] ?? '0'}',
                                    ),
                                  );
                                  productController.calculateSummary();
                                  clientController
                                      .setSelectedCustomerIdWithOk();
                                  productController.setSelectedDiscountTypeId(
                                    '-1',
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      Divider(color: Others.divider),
                      gapH10,
                      Text(
                        'payment_method'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      gapH10,
                      SizedBox(
                        height: Sizes.deviceHeight * 0.2,
                        child: ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          itemCount: paymentCont.paymentMethodList.length,
                          itemBuilder:
                              (context, index) =>
                                  '${paymentCont.paymentMethodList[index]['active']}' ==
                                          '1'
                                      ? '${paymentCont.paymentMethodList[index]['title']}' ==
                                                  'On Account' &&
                                              clientController
                                                      .selectedCustomerIdWithOk !=
                                                  '-1'
                                          ? _cashingMethodCard(
                                            index: index,
                                            onTapFunction: () {
                                              paymentCont
                                                  .setClickedPaymentMethodeId(
                                                    '${paymentCont.paymentMethodList[index]['id']}',
                                                  );
                                              paymentCont
                                                  .setClickedPaymentMethodeIndex(
                                                    index,
                                                  );
                                              paymentCont
                                                  .setIsClickedPaymentMethodeVisaOrMaster(
                                                    false,
                                                  );
                                            },
                                            methodInfo:
                                                paymentCont
                                                    .paymentMethodList[index],
                                          )
                                          : '${paymentCont.paymentMethodList[index]['title']}' !=
                                              'On Account'
                                          ? _cashingMethodCard(
                                            index: index,
                                            onTapFunction: () {
                                              paymentCont
                                                  .setClickedPaymentMethodeId(
                                                    '${paymentCont.paymentMethodList[index]['id']}',
                                                  );
                                              paymentCont
                                                  .setClickedPaymentMethodeIndex(
                                                    index,
                                                  );
                                              if ('${paymentCont.paymentMethodList[index]['title']}' ==
                                                  'Master') {
                                                paymentCont
                                                    .setIsClickedPaymentMethodeMaster(
                                                      true,
                                                    );
                                              } else if ('${paymentCont.paymentMethodList[index]['title']}' ==
                                                  'Visa') {
                                                paymentCont
                                                    .setIsClickedPaymentMethodeVisa(
                                                      true,
                                                    );
                                              } else {
                                                paymentCont
                                                    .setIsClickedPaymentMethodeVisaOrMaster(
                                                      false,
                                                    );
                                              }
                                            },
                                            methodInfo:
                                                paymentCont
                                                    .paymentMethodList[index],
                                          )
                                          : const SizedBox()
                                      : const SizedBox(),
                        ),
                      ),
                      gapH6,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Others.btnBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'cashback_assistant'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        MobileReusableCurrencyCard(
                                          onTapFunction: () {
                                            setState(() {
                                              paymentCont.setPaymentCurrency(
                                                productController
                                                    .primaryCurrency,
                                              );
                                              customerPaidController
                                                  .text = double.parse(
                                                ('${double.parse(customerPaidController.text) / double.parse('${productController.latestRate}')}'),
                                              ).toStringAsFixed(2);
                                              paymentController.setEnteredValue(
                                                customerPaidController.text,
                                              );
                                            });
                                          },
                                          text:
                                              productController.primaryCurrency,
                                        ),
                                        gapW10,
                                        productController.primaryCurrency ==
                                                productController.posCurrency
                                            ? SizedBox()
                                            : MobileReusableCurrencyCard(
                                              onTapFunction: () {
                                                setState(() {
                                                  paymentCont
                                                      .setPaymentCurrency(
                                                        productController
                                                            .posCurrency,
                                                      );
                                                  customerPaidController
                                                      .text = double.parse(
                                                    '${double.parse(customerPaidController.text) * double.parse('${productController.latestRate}')}',
                                                  ).toStringAsFixed(2);
                                                  paymentController
                                                      .setEnteredValue(
                                                        customerPaidController
                                                            .text,
                                                      );
                                                });
                                              },
                                              text:
                                                  productController.posCurrency,
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            gapH10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      child: ReusableNumberField(
                                        onChangedFunc: (value) {},
                                        validationFunc: (val) {},
                                        hint: 'customer_paid'.tr,
                                        isPasswordField: false,
                                        textEditingController:
                                            customerPaidController,
                                      ),
                                    ),
                                    gapW4,
                                    InkWell(
                                      onTap: () {
                                        if (double.parse(
                                              customerPaidController.text,
                                            ) !=
                                            0.0) {
                                          var currency =
                                              paymentCont.paymentCurrency;
                                          // cont.setClickedPaymentMethodeId(
                                          //     '${cont.paymentMethodList[index]['id']}');
                                          if (paymentCont
                                                  .paymentMethodList[paymentCont
                                                  .clickedPaymentMethodeIndex]['title'] ==
                                              'On Account') {
                                            if (paymentCont
                                                    .isOnAccountSelected ==
                                                false) {
                                              Map method = {
                                                'id':
                                                    paymentCont
                                                        .clickedPaymentMethodeId,
                                                'title':
                                                    paymentCont
                                                        .paymentMethodList[paymentCont
                                                        .clickedPaymentMethodeIndex]['title'],
                                                'active':
                                                    paymentCont
                                                        .paymentMethodList[paymentCont
                                                        .clickedPaymentMethodeIndex]['active'],
                                                'price': double.parse(
                                                  customerPaidController.text,
                                                ).toStringAsFixed(2),
                                                'currency': currency,
                                                'authCode ': '',
                                              };
                                              paymentCont
                                                  .setIsOnAccountSelected(true);
                                              int index =
                                                  paymentCont
                                                      .selectedCashingMethodsList
                                                      .length;
                                              paymentController
                                                  .addToSelectedMethodsList(
                                                    method,
                                                  );
                                              paymentCont.setOnAccountIndex(
                                                index,
                                              );
                                            } else {
                                              paymentCont
                                                  .setPriceAndCurrencyOnAccount(
                                                    double.parse(
                                                      customerPaidController
                                                          .text,
                                                    ).toStringAsFixed(2),
                                                    currency,
                                                  );
                                            }
                                          } else {
                                            Map method = {
                                              'id':
                                                  paymentCont
                                                      .clickedPaymentMethodeId,
                                              'title':
                                                  paymentCont
                                                      .paymentMethodList[paymentCont
                                                      .clickedPaymentMethodeIndex]['title'],
                                              'active':
                                                  paymentCont
                                                      .paymentMethodList[paymentCont
                                                      .clickedPaymentMethodeIndex]['active'],
                                              'price': double.parse(
                                                customerPaidController.text,
                                              ).toStringAsFixed(2),
                                              'currency': currency,
                                              'authCode': '',
                                              // 'authCode':paymentCont.paymentMethodList[paymentCont
                                              //     .clickedPaymentMethodeIndex]
                                              // ['title'] == 'Master'?authCodeForMasterController.text:authCodeForVisaController.text
                                            };
                                            paymentController
                                                .addToSelectedMethodsList(
                                                  method,
                                                );
                                          }
                                          paymentCont.calculateRemAndChange();
                                          paymentCont.setEnteredValue(
                                            paymentController.paymentCurrency ==
                                                    productController
                                                        .primaryCurrency
                                                ? '${paymentController.primaryCurrencyRemaining}'
                                                : '${paymentController.remainingWithExchange}',
                                          );
                                          customerPaidController.text =
                                              paymentController
                                                          .paymentCurrency ==
                                                      productController
                                                          .primaryCurrency
                                                  ? '${paymentController.primaryCurrencyRemaining}'
                                                  : '${paymentController.remainingWithExchange}';
                                        }
                                      },
                                      child: Text('add'.tr),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [Text('change'.tr)],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${productController.primaryCurrency} ${paymentCont.primaryCurrencyChange}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          '  ${productController.posCurrency} ${paymentCont.changeWithExchange}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Sizes.deviceHeight * 0.15,
                        child: ListView.builder(
                          itemCount:
                              paymentCont.selectedCashingMethodsList.length,
                          itemBuilder: (context, index) {
                            // var keys =
                            //     cont.selectedMethodsList.keys.toList();
                            return SelectedPaymentMethodeCard(
                              onTapFunction: () {
                                paymentCont.setClickedPaymentMethodeId(
                                  '${paymentCont.selectedCashingMethodsList[index]['id']}',
                                );
                              },
                              onRemoveFunction: () {
                                if (paymentCont
                                        .selectedCashingMethodsList[index]['title'] ==
                                    'On Account') {
                                  paymentCont.setIsOnAccountSelected(false);
                                }
                                paymentCont.removeFromSelectedMethodsList(
                                  paymentCont.selectedCashingMethodsList[index],
                                );
                                // cont.removeFromSelectedMethodsList(
                                //     '${cont.selectedMethodsList[keys[index]]['id']}');
                              },
                              methodInfo:
                                  paymentCont.selectedCashingMethodsList[index],
                              // cont.selectedMethodsList[keys[index]],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<ProductController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        SizedBox(
                          // height: Sizes.deviceHeight * 0.3,
                          child: Table(
                            border: TableBorder.all(color: Colors.white),
                            columnWidths: {
                              0: FixedColumnWidth(Sizes.deviceWidth * 0.2),
                              1: FixedColumnWidth(Sizes.deviceWidth * 0.1),
                              2: FixedColumnWidth(Sizes.deviceWidth * 0.4),
                            },
                            children:
                                controller.primaryCurrency ==
                                            controller.posCurrency &&
                                        homeController.companySubjectToVat ==
                                            '1'
                                    ? [
                                      TableRow(
                                        children: [
                                          Text(
                                            '${'total'.tr}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.posCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.totalPrice
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Text(
                                            '${'Vat'}:',
                                            // style: TextStyle(
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                          ),
                                          Text(controller.posCurrency),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.taxesSum
                                                      .toString(),
                                                ),
                                          ),
                                        ],
                                      ),
                                      // TableRow(
                                      //   children: [
                                      //     Text('${'discount'.tr}:'),
                                      //     Text(controller.posCurrency),
                                      //     Text(
                                      //       controller.isWasteClicked ||
                                      //               controller
                                      //                   .orderItemsList
                                      //                   .isEmpty
                                      //           ? '0'
                                      //           : numberWithComma(
                                      //             (controller.totalDiscount)
                                      //                 .toString(),
                                      //           ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ]
                                    : controller.primaryCurrency ==
                                            controller.posCurrency &&
                                        homeController.companySubjectToVat !=
                                            '1'
                                    ? [
                                      TableRow(
                                        children: [
                                          Text(
                                            '${'total'.tr}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.posCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.totalPrice
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // TableRow(
                                      //   children: [
                                      //     Text('${'discount'.tr}:'),
                                      //     Text(controller.posCurrency),
                                      //     Text(
                                      //       controller.isWasteClicked ||
                                      //               controller
                                      //                   .orderItemsList
                                      //                   .isEmpty
                                      //           ? '0'
                                      //           : numberWithComma(
                                      //             (controller.totalDiscount)
                                      //                 .toString(),
                                      //           ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ]
                                    : controller.primaryCurrency !=
                                            controller.posCurrency &&
                                        homeController.companySubjectToVat !=
                                            '1'
                                    ? [
                                      TableRow(
                                        children: [
                                          Text(
                                            '${'total'.tr}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.posCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.totalPrice
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Text(''),
                                          Text(
                                            controller.primaryCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller
                                                      .totalPriceWithExchange
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // TableRow(
                                      //   children: [
                                      //     Text('${'discount'.tr}:'),
                                      //     Text(controller.posCurrency),
                                      //     Text(
                                      //       controller.isWasteClicked ||
                                      //               controller
                                      //                   .orderItemsList
                                      //                   .isEmpty
                                      //           ? '0'
                                      //           : numberWithComma(
                                      //             (controller.totalDiscount)
                                      //                 .toString(),
                                      //           ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ]
                                    : [
                                      TableRow(
                                        children: [
                                          Text(
                                            '${'total'.tr}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.posCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.totalPrice
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Text(''),
                                          Text(
                                            controller.primaryCurrency,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller
                                                      .totalPriceWithExchange
                                                      .toString(),
                                                ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Text(
                                            '${'Vat'}:',
                                            // style: TextStyle(
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                          ),
                                          Text(controller.posCurrency),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller.taxesSum
                                                      .toString(),
                                                ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const Text(''),
                                          Text(controller.primaryCurrency),
                                          Text(
                                            controller.isWasteClicked
                                                ? '0'
                                                : numberWithComma(
                                                  controller
                                                      .taxesSumWithExchange
                                                      .toString(),
                                                ),
                                          ),
                                        ],
                                      ),
                                      // TableRow(
                                      //   children: [
                                      //     Text('${'discount'.tr}:'),
                                      //     Text(controller.posCurrency),
                                      //     Text(
                                      //       controller.isWasteClicked ||
                                      //               controller
                                      //                   .orderItemsList
                                      //                   .isEmpty
                                      //           ? '0'
                                      //           : numberWithComma(
                                      //             (controller.totalDiscount)
                                      //                 .toString(),
                                      //           ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                          ),
                        ),
                        gapH16,
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.close, color: Primary.primary),
                                label: Text(
                                  "close".tr,
                                  style: TextStyle(color: Primary.primary),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Primary.primary),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    (paymentCont.primaryCurrencyRemaining
                                                        .toStringAsFixed(2) ==
                                                    '0.00' &&
                                                paymentCont
                                                    .selectedCashingMethodsList
                                                    .isNotEmpty) ||
                                            clientController
                                                    .selectedCustomerIdWithOk !=
                                                '-1' ||
                                            productController.totalPrice
                                                    .toStringAsFixed(2) ==
                                                '0.00' ||
                                            clientController
                                                    .selectedCustomerIdWithOk !=
                                                '-1'
                                        ? () async {
                                          {
                                            showDialog<String>(
                                              context: context,
                                              builder:
                                                  (
                                                    BuildContext context,
                                                  ) => const AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  9,
                                                                ),
                                                              ),
                                                        ),
                                                    elevation: 0,
                                                    content: LoadingDialog(),
                                                  ),
                                            );
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
                                            var cashTrayRes =
                                                await getOpenCashTrayId(
                                                  currentSessionId,
                                                  userId,
                                                );
                                            if ('$cashTrayRes' != '[]') {
                                              cashTrayId =
                                                  '${cashTrayRes['id']}';
                                            }
                                            double usdRemainingOnAccount = 0,
                                                remainingWithExchangeOnAccount =
                                                    0;
                                            if (paymentCont
                                                .isOnAccountSelected) {
                                              if (paymentCont
                                                      .selectedCashingMethodsList[paymentCont
                                                      .onAccountIndex]['currency'] ==
                                                  productController
                                                      .primaryCurrency) {
                                                usdRemainingOnAccount = double.parse(
                                                  paymentCont
                                                      .selectedCashingMethodsList[paymentCont
                                                      .onAccountIndex]['price'],
                                                );
                                                remainingWithExchangeOnAccount =
                                                    usdRemainingOnAccount *
                                                    double.parse(
                                                      '${productController.latestRate}',
                                                    );
                                              } else {
                                                remainingWithExchangeOnAccount =
                                                    double.parse(
                                                      paymentCont
                                                          .selectedCashingMethodsList[paymentCont
                                                          .onAccountIndex]['price'],
                                                    );
                                                usdRemainingOnAccount =
                                                    remainingWithExchangeOnAccount /
                                                    double.parse(
                                                      '${productController.latestRate}',
                                                    );
                                              }
                                            }
                                            if (!productController
                                                .isRetrieveOrderSelected) {
                                              var parkRes = await addOrder(
                                                productController
                                                    .orderItemsList,
                                                productController
                                                    .taxesSumWithExchange
                                                    .toStringAsFixed(2),
                                                productController
                                                        .orderItemsList
                                                        .isNotEmpty
                                                    ? '${productController.totalDiscountWithExchange}'
                                                    : '0',
                                                productController.taxesSum
                                                    .toStringAsFixed(2),
                                                productController
                                                        .orderItemsList
                                                        .isNotEmpty
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
                                                '', //noteController.text
                                                productController
                                                            .selectedDiscountTypeId ==
                                                        '-1'
                                                    ? true
                                                    : false,
                                                clientController
                                                            .selectedCustomerIdWithOk ==
                                                        '-1'
                                                    ? ''
                                                    : clientController
                                                        .selectedCustomerIdWithOk,
                                                cashTrayId,
                                                productController
                                                    .totalDiscountAsPercent
                                                    .toString(),
                                                clientController.selectedCarId,
                                              );
                                              // Get.back();
                                              if (parkRes != 'error') {
                                                ordersController
                                                    .setSelectedOrderId(
                                                      '${parkRes['id']}',
                                                    );
                                                var p = await finishOrder(
                                                  roleName,
                                                  cashTrayId,
                                                  ordersController
                                                      .selectedOrderId,
                                                  paymentController
                                                      .selectedCashingMethodsList,
                                                  paymentController
                                                      .primaryCurrencyChange
                                                      .toStringAsFixed(2),
                                                  paymentController
                                                      .changeWithExchange
                                                      .toStringAsFixed(2),
                                                  paymentCont
                                                          .isOnAccountSelected
                                                      ? usdRemainingOnAccount
                                                          .toStringAsFixed(2)
                                                      : paymentController
                                                          .primaryCurrencyRemaining
                                                          .toStringAsFixed(2),
                                                  paymentCont
                                                          .isOnAccountSelected
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
                                                  clientController
                                                      .selectedCarId,
                                                );
                                                Get.back();
                                                if (p['success'] == true) {
                                                  Get.back();
                                                  paymentCont.setInvoiceNumber(
                                                    p['data']['orderNumber'],
                                                  );
                                                  showDialog<String>(
                                                    // ignore: use_build_context_synchronously
                                                    context: context,
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                        ) => AlertDialog(
                                                          contentPadding:
                                                              EdgeInsets.all(3),
                                                          insetPadding:
                                                              EdgeInsets.all(
                                                                15,
                                                              ),
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    9,
                                                                  ),
                                                                ),
                                                          ),
                                                          elevation: 0,
                                                          content:
                                                              PaymentSuccessPage(),
                                                        ),
                                                  );
                                                } else {
                                                  Get.back();
                                                  CommonWidgets.snackBar(
                                                    'error',
                                                    p['message'],
                                                  );
                                                }
                                              } else {
                                                CommonWidgets.snackBar(
                                                  'error',
                                                  'error'.tr,
                                                );
                                              }
                                            } else {
                                              var updateRes = await updateOrder(
                                                productController
                                                    .orderItemsList,
                                                ordersController
                                                    .selectedOrderId,
                                                productController
                                                    .taxesSumWithExchange
                                                    .toStringAsFixed(2),
                                                productController
                                                        .orderItemsList
                                                        .isNotEmpty
                                                    ? '${productController.totalDiscountWithExchange}'
                                                    : '0',
                                                productController.taxesSum
                                                    .toStringAsFixed(2),
                                                productController
                                                        .orderItemsList
                                                        .isNotEmpty
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
                                                '', //noteController.text
                                              );
                                              if (updateRes != 'error') {
                                                var p = await finishOrder(
                                                  roleName,
                                                  cashTrayId,
                                                  ordersController
                                                      .selectedOrderId,
                                                  paymentController
                                                      .selectedCashingMethodsList,
                                                  paymentController
                                                      .primaryCurrencyChange
                                                      .toStringAsFixed(2),
                                                  paymentController
                                                      .changeWithExchange
                                                      .toStringAsFixed(2),
                                                  paymentCont
                                                          .isOnAccountSelected
                                                      ? usdRemainingOnAccount
                                                          .toStringAsFixed(2)
                                                      : paymentController
                                                          .primaryCurrencyRemaining
                                                          .toStringAsFixed(2),
                                                  paymentCont
                                                          .isOnAccountSelected
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
                                                  clientController
                                                      .selectedCarId,
                                                );
                                                Get.back();
                                                if (p['success'] == true) {
                                                  Get.back();
                                                  paymentCont.setInvoiceNumber(
                                                    p['data']['orderNumber'],
                                                  );
                                                  homeController.setSelectedTab(
                                                    'print',
                                                  );
                                                } else {
                                                  Get.back();
                                                  CommonWidgets.snackBar(
                                                    'error',
                                                    p['message'],
                                                  );
                                                }
                                              }
                                            }
                                          }
                                        }
                                        : null,
                                icon: const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                                label: Text("pay".tr),
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Primary.primary),
                                  backgroundColor: Primary.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cashingMethodCard({
    required Map methodInfo,
    required Function onTapFunction,
    required int index,
  }) {
    return GetBuilder<PaymentController>(
      builder: (cont) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    child: CachedNetworkImage(
                      imageUrl:
                          (methodInfo['image'] != null &&
                                  methodInfo['image'].isNotEmpty)
                              ? '$baseImage${methodInfo['image']}'
                              : 'https://cdn-icons-png.flaticon.com/512/633/633611.png',
                      height: 43,
                      width: 43,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => loading(),
                      // errorWidget: (context, url, error) => loading(),
                      errorWidget: (context, url, error) {
                        //print("Error loading image: $error"); // Debug error message
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: 40,
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     // shape: BoxShape.circle,
                  //     // color: Colors.red,
                  //     borderRadius: BorderRadius.circular(9),
                  //     image: DecorationImage(
                  //       // image: AssetImage('assets/images/boxes.png'),
                  //       image: NetworkImage('https://via.placeholder.com/150'),
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // ),
                  gapW12,
                  Text(methodInfo['title']),
                ],
              ),
              Radio(
                value: index + 1,
                groupValue: cont.selectedCashMethodOption,
                onChanged: (value) {
                  cont.setSelectedCashMethodOption(value!);
                  onTapFunction();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
