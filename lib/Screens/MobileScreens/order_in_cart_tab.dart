import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/MobileScreens/payment_dialog.dart';
import 'package:pos_project/Widgets/custom_snak_bar.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';

import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../../const/functions.dart';

ScrollController _scrollController = ScrollController();

class OrderInCartTab extends StatefulWidget {
  const OrderInCartTab({super.key});

  @override
  State<OrderInCartTab> createState() => _OrderInCartTabState();
}

class _OrderInCartTabState extends State<OrderInCartTab> {
  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();
  HomeController homeController = Get.find();
  OrdersController ordersController = Get.find();

  @override
  void initState() {
    super.initState();
    // productController.productsList = [];
    // productController.currentPage = 1;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollControllerForGridView.addListener(() {
    //     if (scrollControllerForGridView.position.pixels >=
    //             scrollControllerForGridView.position.maxScrollExtent &&
    //         !productController.isLoading) {
    //       productController.getAllProductsFromBack();
    //     }
    //   });
    // });
    // getInfoFromPref();
    // getCategoriesFromBack();
    // productController.getAllProductsFromBack();
    // productController.selectedCustomerId = '-1';
    // productController.selectedCustomerIdWithOk = '-1';
    // productController.selectedCustomerObject = {};
    // getInfoFromPref();
    // getCurrenciesFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (proCont) {
        return Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
            //   child: DialogTextField(
            //     // hint: 'search_by'.tr,
            //     hint: 'scan_barcode'.tr,
            //     textEditingController: mobileSearchByBarcodeController,
            //     textFieldWidth: MediaQuery.of(context).size.width ,
            //     validationFunc: (value) {},
            //     onIconClickedFunc: () {
            //       // Get.to(()=>const CameraScannerPage());
            //       // homeController.selectedTab.value =
            //       //     'camera_scanner_page';
            //       Navigator.push(context, MaterialPageRoute(
            //           builder: (BuildContext context) {
            //             return const MobileBarcodeScannerPage();
            //           }));
            //     },
            //     isHasCloseIcon: true,
            //     onCloseIconClickedFunc: () async {
            //       mobileSearchByBarcodeController.clear();
            //       searchByBarcodeOrNameController.clear();
            //       await productController
            //           .getAllProductsFromBackWithSearch();
            //     },
            //     onChangedFunc: (val) async {
            //       searchByBarcodeOrNameController.text=val;
            //       const duration = Duration(
            //           milliseconds:
            //           800); // set the duration that you want call search() after that.
            //       if (searchOnStoppedTyping != null) {
            //         setState(() => searchOnStoppedTyping!
            //             .cancel()); // clear timer
            //       }
            //       setState(() => searchOnStoppedTyping =
            //           Timer(duration, () async {
            //             await productController
            //                 .getAllProductsFromBackWithSearch();
            //             if (proCont.productsList.length == 1) {
            //               WidgetsBinding.instance
            //                   .addPostFrameCallback((_) {
            //                 if (_scrollController.hasClients) {
            //                   _scrollController.animateTo(
            //                     _scrollController
            //                         .position.maxScrollExtent,
            //                     curve: Curves.easeOut,
            //                     duration: const Duration(
            //                         milliseconds: 1),
            //                   );
            //                 }
            //               });
            //               String id =
            //                   '${proCont.productsList[0]['id']}';
            //               if(proCont.orderItemsList.keys.toList().contains(id)){
            //                 proCont.orderItemsList[id]['quantity']='${
            //                     double.parse(proCont.orderItemsList[id]['quantity'])+1
            //                 }';
            //               }else{
            //                 double tax = proCont.productsList[0]
            //                 ['taxation'] /
            //                     100.0;
            //
            //                 // double usdPrice = 0.0,
            //                 //     otherCurrencyPrice = 0.0;
            //                 // var priceCurrency = proCont.productsList[0]['priceCurrency']['name'];
            //                 var resultForPrice = proCont
            //                     .productsList[0]['priceCurrency']['latest_rate']
            //                     .isEmpty
            //                     ? '1'
            //                     : proCont
            //                     .productsList[0]['priceCurrency']['latest_rate'];
            //                 var showPriceLatestRate =
            //                 resultForPrice != null ? '$resultForPrice' : '1';
            //                 var price = double.parse(
            //                     '${proCont.productsList[0]['unitPrice']}');
            //                 // var showInCardCurrencyPrice = double.parse(
            //                 //     '${Decimal.parse('$price') * Decimal.parse('$productLatestRate')}');
            //
            //                 var rateToPos = calculateRateCur1ToCur2(
            //                     double.parse(showPriceLatestRate),
            //                     double.parse(
            //                         productController.posCurrencyLatestRate));
            //                 var showInPosCurrencyPrice = double.parse(
            //                     '${Decimal.parse('$price') *
            //                         Decimal.parse(rateToPos)}');
            //
            //                 price = roundUp(price, 2);
            //                 showInPosCurrencyPrice =
            //                     roundUp(showInPosCurrencyPrice, 2);
            //
            //                 Map p = {
            //                   'id': '${proCont.productsList[0]['id']}',
            //                   'item_name': proCont
            //                       .productsList[0]['item_name'],
            //                   'quantity': '1',
            //                   'available_qty': proCont
            //                       .productsList[0]['quantity'],
            //                   'tax': tax,
            //                   'percent_tax': proCont.productsList[0]
            //                   ['taxation'],
            //                   'discount': 0,
            //                   'discount_percent': 0,
            //                   'discount_type_id': '',
            //                   'original_price':
            //                   price,
            //                   //widget.product['unitPrice'],
            //                   'price':
            //                   '$showInPosCurrencyPrice',
            //                   // widget.product['unitPrice'],
            //                   'UnitPrice': price,
            //                   // widget.product['unitPrice'],
            //                   'final_price':
            //                   showInPosCurrencyPrice,
            //                   // widget.product['unitPrice'],
            //                   'symbol': proCont.productsList[0]
            //                   ['posCurrency']['symbol'] ??
            //                       '',
            //                   'sign':
            //                   proCont.isReturnClicked ? '-' : ''
            //                 };
            //
            //                 if (homeController.isSessionToday) {
            //                   proCont.addToOrderItemsList(id, p);
            //
            //                   proCont.calculateSummary();
            //                 }
            //               }
            //             }
            //           }));
            //     },
            //     radius: 9,
            //   ),
            // ),
            gapH20,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                // height: MediaQuery.of(context).size.height * 0.45,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: proCont.orderItemsList.keys.toList().length,
                        itemBuilder: (context, index) {
                          var keys = proCont.orderItemsList.keys.toList();
                          return _orderItem(proCont.orderItemsList[keys[index]]);
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'total'.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                gapW4,
                                Text(
                                  '(${proCont.orderItemsList.length} ${'items'.tr})',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Text(
                              proCont.isWasteClicked
                                  ? '0'
                                  : '${proCont.posCurrency} ${numberWithComma(proCont.totalPrice.toString())}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        gapH10,
                        ReusableButtonWithColor(btnText: 'checkout'.tr,
                            onTapFunction: (){
                          if(proCont.isCashAvailable && homeController.isSessionToday && proCont.orderItemsList.isNotEmpty){
                          showDialog<String>(
                            // ignore: use_build_context_synchronously
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    contentPadding: EdgeInsets.all(3),
                                      insetPadding: EdgeInsets.all(15),
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                      ),
                                      elevation: 0,
                                      content: PaymentDialog(
                                      )));
                        }else{
                            if(proCont.isCashAvailable && homeController.isSessionToday){
                              CommonWidgets.snackBar('error','Select An Item To Sell First');
                            }else{
                            CommonWidgets.snackBar('error',homeController.isSessionToday
                                ? 'Open Cash Tray First'
                                :'You can\'t create a new order before closing this session and opening a new one.');
                            }
                          }
                          }, width: MediaQuery.of(context).size.width,
                            height: 50)
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _orderItem(Map product) {
    return GetBuilder<ProductController>(
      builder: (controller) {
        // double tax=product['unitPrice'] *
        //     (product['taxation'] / 100.0);
        return Column(
          children: [
            InkWell(
              onTap: () {
                if (controller.isReturnClicked) {
                  controller.orderItemsList['${product['id']}']['sign'] = '-';
                  controller.calculateSummary();
                }
                setState(() {
                  controller.setSelectedOrderItemId('${product['id']}');
                  controller.setIsFirstClickVal('${product['id']}', true);
                  // controller.setSelectedOrderItemIndex(product['index']);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 3),
                decoration:
                    '${product['id']}' == controller.selectedOrderItemId
                        ? BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                        )
                        : const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.selectedOrderItemId ==
                                '${product['id']}') {
                              controller.setSelectedOrderItemId('');
                            }
                            controller.removeFromOrderItemsList(
                              '${product['id']}',
                            );
                            controller.calculateSummary();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product['item_name'] ?? ''} ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${product['sign'] ?? ''}${numberWithComma(product['final_price'].toString())} ${controller.posCurrency}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    gapH6,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              _quantityButton(Icons.remove, () {
                                if (double.parse('${controller
                                    .orderItemsList['${product['id']}']['quantity']}') >
                                    1) {
                                  controller
                                      .orderItemsList['${product['id']}']['quantity'] =
                                     '${double.parse('${controller
                                        .orderItemsList['${product['id']}']['quantity']}') - 1}';
                                  controller
                                      .orderItemsList['${product['id']}']['final_price'] =
                                      double.parse('${controller
                                          .orderItemsList['${product['id']}']['price']}') *
                                          double.parse('${controller
                                              .orderItemsList['${product['id']}']['quantity']}');

                                  controller.calculateSummary();
                                }

                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  '${product['quantity']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              _quantityButton(Icons.add, () {
                                if (double.parse(
                                  '${controller.orderItemsList['${product['id']}']['quantity']}',
                                ) <
                                    double.parse(
                                      '${controller.orderItemsList['${product['id']}']['available_qty']}',
                                    )) {
                                  controller
                                      .orderItemsList['${product['id']}']['quantity'] =
                                  '${double.parse('${controller.orderItemsList['${product['id']}']['quantity']}') + 1}';

                                  controller
                                      .orderItemsList['${product['id']}']['final_price'] =
                                      double.parse(
                                        '${controller.orderItemsList['${product['id']}']['price']}',
                                      ) *
                                          double.parse(
                                            '${controller.orderItemsList['${product['id']}']['quantity']}',
                                          );

                                  controller.calculateSummary();

                                }
                              }),
                            ],
                          ),
                        ),
                        Text(
                          '${controller.posCurrency} ${numberWithComma(double.parse(product['price']).toString())} /  ${'item'.tr}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: Others.divider),
            ),
          ],
        );
      },
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Icon(icon, color: Primary.primary, size: 20),
    );
  }
}
