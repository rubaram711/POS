import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/client_controller.dart';
import 'package:pos_project/Controllers/orders_controller.dart';
import '../../../Controllers/home_controller.dart';
import '../../../Controllers/payment_controller.dart';
import '../../../Controllers/products_controller.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../Widgets/table_item.dart';
import '../../../Widgets/table_title.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../const/functions.dart';
import 'choose_pint_format_dialog.dart';


class MobileDocs extends StatefulWidget {
  const MobileDocs({super.key});

  @override
  State<MobileDocs> createState() => _MobileDocsState();
}

class _MobileDocsState extends State<MobileDocs> {
  final OrdersController ordersController = Get.find();
  final HomeController homeController = Get.find();
  final ProductController productController = Get.find();

  bool isArrowBackClickedInGeneral = false;
  bool isArrowForwardClickedInGeneral = false;
  int startInTransactions = 1;
  bool isArrowBackClickedInTransactions = false;
  bool isArrowForwardClickedInTransactions = false;

  String searchValue = '';
  Timer? searchOnStoppedTyping;
  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
        800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(
            () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    setState(() {
      searchValue = value;
      ordersController.setIsOrdersFetched(false);
      ordersController.setOrders([]);
    });
    await ordersController.getAllOrdersFromBack();
  }

  @override
  void initState() {
    ordersController.orders = [];
    ordersController.isOrdersFetched = false;
    ordersController.selectedDocIndex = -1;
    ordersController.searchController.clear();
    ordersController.filterController.clear();
    ordersController.getAllOrdersFromBack();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 140;
    return Scaffold(
      appBar: AppBar(
        title: Text('orders'.tr),
      ),
      body: GetBuilder<OrdersController>(builder: (orderCont) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          // width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  gapH4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.53,
                        child: ReusableSearchTextField(
                          hint: '${"search".tr}...',
                          textEditingController: orderCont.searchController,
                          onChangedFunc: (val) {
                            orderCont.searchController.text = val;
                            _onChangeHandler(val);
                          },
                          validationFunc: (val) {},
                        ),
                      ),
                      DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width * 0.4,
                        requestFocusOnTap: false,
                        // enableSearch: false,
                        hintText: 'all_docs'.tr,
                        inputDecorationTheme: InputDecorationTheme(
                          // filled: true,
                          hintStyle:
                          const TextStyle(fontStyle: FontStyle.italic),
                          contentPadding:
                          const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          // outlineBorder: BorderSide(color: Colors.black,),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Primary.primary
                                    .withAlpha((0.2 * 255).toInt()),
                                width: 1),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Primary.primary
                                    .withAlpha((0.4 * 255).toInt()),
                                width: 2),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                          ),
                        ),
                        // menuStyle: ,
                        menuHeight: 250,
                        dropdownMenuEntries: orderCont.filtersList
                            .map<DropdownMenuEntry<String>>(
                                (String option) {
                              return DropdownMenuEntry<String>(
                                value: option,
                                label: option,
                              );
                            }).toList(),
                        // enableFilter: true,
                        onSelected: (String? val) {
                          if (val == 'All Orders') {
                            orderCont.filterController.text = '';
                          } else {
                            orderCont.filterController.text = val!;
                          }
                          orderCont.getAllOrdersFromBack();
                        },
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Primary.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    TableTitle(
                                      text: 'date'.tr,
                                      width: width,
                                    ),
                                    TableTitle(
                                      text: 'doc_number'.tr,
                                      width: width,
                                    ),
                                    TableTitle(
                                      text: 'customer'.tr,
                                      width: width,
                                    ),
                                    TableTitle(
                                      text: 'cashier'.tr,
                                      width: width,
                                    ),
                                    TableTitle(
                                      text: 'total'.tr,
                                      width: width,
                                    ),
                                    // TableTitle(
                                    //   text: '${'total'.tr}',
                                    //   width: MediaQuery.of(context).size.width * 0.07,
                                    // ),
                                    TableTitle(
                                      text: 'status'.tr,
                                      width: width,
                                    ),
                                    TableTitle(
                                      text: 'cashing_methods'.tr,
                                      width: width,
                                    ),
                                  ],
                                ),
                              ),
                              orderCont.isOrdersFetched
                                  ? Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: List.generate(
                                  orderCont.orders.length,
                                      (index) => Column(
                                        children: [
                                          OrdersAsRowInTable(
                                            info: orderCont.orders[index],
                                            index: index,
                                          ),
                                          const Divider()
                                        ],
                                      )
                                ),
                              )
                                  : const CircularProgressIndicator(),
      
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class OrdersAsRowInTable extends StatefulWidget {
  const OrdersAsRowInTable(
      {super.key, required this.info, required this.index});
  final Map info;
  final int index;

  @override
  State<OrdersAsRowInTable> createState() => _OrdersAsRowInTableState();
}

class _OrdersAsRowInTableState extends State<OrdersAsRowInTable> {
  bool isHovered = false;
  final HomeController homeController = Get.find();
  final OrdersController ordersController = Get.find();
  final PaymentController paymentController = Get.find();
  @override
  Widget build(BuildContext context) {
    double width = 140;
    return InkWell(
      onHover: (val) {
        setState(() {
          isHovered = val;
        });
      },
      onTap: () {
        // print(widget.info['pos_currency']);
        ordersController.setSelectedDocIdAndIndex(
            '${widget.info['id']}', widget.index);
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
                    content: OrderDetails(
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        decoration: BoxDecoration(
            color: isHovered
                ? Primary.primary.withAlpha((0.2 * 255).toInt())
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(0))),
        child: Row(
          children: [
            TableItem(
              text:
              '${widget.info['date'] ?? ''}', //convertTimeZoneToDateAndTime('${widget.info['created_at']}'),
              width: width,
            ),
            TableItem(
              text: '${widget.info['docNumber'] ?? ''}',
              width: width,
            ),
            TableItem(
              text: '${widget.info['client']['name'] ?? ''}',
              width: width,
            ),
            TableItem(
              text: '${widget.info['cashier'] ?? ''}',
              width: width,
            ),
            TableItem(
              text: widget.info['posCurrencyTotal'] != null
                  ? '${widget.info['posCurrencyTotal'].toStringAsFixed(2) ?? ''} ${widget.info['posCurrency']['symbol']}'
                  : '',
              width: width,
            ),
            TableItem(
              text: '${widget.info['status'] ?? ''}',
              width: width,
            ),
            TableItem(
              text:widget.info['cashing_methods'].isNotEmpty? widget.info['cashing_methods'] :'',
              // text:widget.info['cashing_methods'].isNotEmpty? widget.info['cashing_methods'].replaceAll(", ", "\n") :'',
              width: width,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemAsRowInTable extends StatefulWidget {
  const OrderItemAsRowInTable(
      {super.key, required this.item, required this.index});
  final Map item;
  final int index;

  @override
  State<OrderItemAsRowInTable> createState() => _OrderItemAsRowInTableState();
}

class _OrderItemAsRowInTableState extends State<OrderItemAsRowInTable> {
  HomeController homeController = Get.find();
  ProductController productController = Get.find();
  // double usdPrice = 0.0, otherCurrencyPrice = 0.0,finalPrice=0.0;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        // color: Primary.primary.withAlpha((0.2 * 255).toInt()),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.item['item_name'] ?? ''} ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      // width: Sizes.deviceWidth * 0.07,
                      child: Text(
                        '${numberWithComma((double.parse('${widget.item['price_after_tax']}')*double.parse('${widget.item['quantity']}')).toStringAsFixed(2))} ${productController.posCurrency}',
                        // '${numberWithComma((   double.parse(
                        //     '${widget.item['price_after_tax']}')*double.parse('${widget.item['quantity']}')).toStringAsFixed(2))} LBP',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                gapH4,
                Row(
                  children: [
                    SizedBox(
                      // width: Sizes.deviceWidth * 0.15,
                      child: Text(
                        '${widget.item['quantity']} ${'units'.tr} '
                            'x ${numberWithComma(double.parse('${widget.item['price_after_tax']}').toStringAsFixed(2))} ${productController.posCurrency}/${'units'.tr}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    widget.item['item_discount'] != null
                        ? Text(
                      '     W/ ${double.parse(widget.item['discount_type']['discount_value'])}%',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                        : const SizedBox()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController=Get.find();
    ClientController clientController=Get.find();
    ProductController productController=Get.find();
    PaymentController paymentController=Get.find();
    return GetBuilder<OrdersController>(
      builder: (orderCont) {
        return Container(
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Others.borderColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Others.borderColor)),
                child:
                ListView.builder(
                  itemCount:orderCont
                      .orders[orderCont.selectedDocIndex]
                  ['orderItems'].length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      OrderItemAsRowInTable(
                        item: orderCont.orders[
                        orderCont.selectedDocIndex]
                        ['orderItems'][index],
                        index: index,
                      ),
                      const Divider()
                    ],
                  ),
                )
                ,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close, color: Primary.primary),
                      label: Text("close".tr, style: TextStyle(color: Primary.primary)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Primary.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:  orderCont.orders[orderCont.selectedDocIndex]
                      ['status'] == 'paid' && homeController.isSessionToday
                          ? () {
                        productController.setSelectedOrderInfo(
                            orderCont
                                .orders[orderCont.selectedDocIndex],
                            true);
                        clientController.setSelectedClientOrderInfo(
                            orderCont
                                .orders[orderCont.selectedDocIndex]);
                        Get.back();
                        Get.back();
                        productController.setSelectedMobileTab(1);
                        // homeController.selectedTab.value = 'Home';
                      }
                          : null,
                      icon: const Icon(Icons.repeat, color: Colors.white),
                      label: Text('refund'.tr),
                      style: ElevatedButton.styleFrom(
                        side:  BorderSide(color: Primary.primary),
                        backgroundColor: Primary.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: homeController.isSessionToday
                          ? () {
                        productController.setSelectedOrderInfo(
                            orderCont
                                .orders[orderCont.selectedDocIndex],
                            false);
                        clientController.setSelectedClientOrderInfo(
                            orderCont
                                .orders[orderCont.selectedDocIndex]);
                        paymentController.setIsReprintedInvoice(true);
                        paymentController.setInvoiceNumber(orderCont.orders[orderCont.selectedDocIndex]['orderNumber']);
                        paymentController.remainingWithExchange=double.parse('${orderCont.orders[orderCont.selectedDocIndex]['posCurrencyRemaining']}');
                        paymentController.primaryCurrencyRemaining=double.parse('${orderCont.orders[orderCont.selectedDocIndex]['primaryCurrencyRemaining']}');
                        paymentController.changeWithExchange=double.parse('${orderCont.orders[orderCont.selectedDocIndex]['posCurrencyChange']}');
                        paymentController.primaryCurrencyChange=double.parse('${orderCont.orders[orderCont.selectedDocIndex]['primaryCurrencyChange']}');
                        paymentController.selectedCashingMethodsList=[];
                        for(var c in orderCont.orders[orderCont.selectedDocIndex]['cashingMethodsDetails']) {
                          if(!(double.parse('${c['pivot']['primary_currency_amount']}')==0 && double.parse('${c['pivot']['pos_currency_amount']}')==0)) {
                            Map method = {
                              'id': c['id'],
                              'title': c['title'],
                              'active': c['active'],
                              'price': double.parse(
                                  '${c['pivot']['primary_currency_amount']}') ==
                                  0
                                  ? double.parse(
                                  '${c['pivot']['pos_currency_amount']}')
                                  .toStringAsFixed(2)
                                  : double.parse(
                                  '${c['pivot']['primary_currency_amount']}')
                                  .toStringAsFixed(2),
                              'currency': double.parse(
                                  '${c['pivot']['primary_currency_amount']}') ==
                                  0
                                  ? productController.posCurrency
                                  : productController.primaryCurrency,
                              'authCode ': c['auth_code'] ?? ''
                            };
                            paymentController
                                .addToSelectedMethodsList(
                                method);
                          }
                        }
                        showDialog<String>(
                          // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
                                ),
                                elevation: 0,
                                content: ChoosePrintFormatDialog()));
                      }
                          : null,
                      icon: const Icon(Icons.print_outlined, color: Colors.white),
                      label: Text('reprint'.tr),
                      style: ElevatedButton.styleFrom(
                        side:  BorderSide(color: Primary.primary),
                        backgroundColor: Primary.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              // Row(
              //   children: [
              //     Tooltip(
              //       message:  homeController.isSessionToday?'':'You can\'t refund before closing this session and opening a new one.',
              //       child: InkWell(
              //         onTap: orderCont.orders[orderCont.selectedDocIndex]
              //         ['status'] == 'paid' && homeController.isSessionToday
              //             ? () {
              //           productController.setSelectedOrderInfo(
              //               orderCont
              //                   .orders[orderCont.selectedDocIndex],
              //               true);
              //           homeController.selectedTab.value = 'Home';
              //         }
              //             : null,
              //         child: Container(
              //           height: Sizes.deviceHeight * 0.12,
              //           width: Sizes.deviceWidth*0.75,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(0),
              //             color:
              //             orderCont.orders[orderCont.selectedDocIndex]
              //             ['status'] ==
              //                 'paid' && homeController.isSessionToday
              //                 ? Primary.primary
              //                 : Primary.primary
              //                 .withAlpha((0.7 * 255).toInt()),
              //           ),
              //           child: Center(
              //               child: Text(
              //                 'refund'.tr,
              //                 style: TextStyle(fontSize: 14, color: Primary.p0),
              //               )),
              //         ),
              //       ),
              //     ),
              //     // Tooltip(
              //     //   message:  homeController.isSessionToday?'':'You can\'t refund before closing this session and opening a new one.',
              //     //   child: InkWell(
              //     //     onTap: orderCont.orders[orderCont.selectedDocIndex]
              //     //     ['status'] == 'paid' && homeController.isSessionToday
              //     //         ? () {
              //     //       productController.setSelectedOrderInfo(
              //     //           orderCont
              //     //               .orders[orderCont.selectedDocIndex],
              //     //           true);
              //     //       homeController.selectedTab.value = 'Home';
              //     //     }
              //     //         : null,
              //     //     child: Container(
              //     //       height: Sizes.deviceHeight * 0.12,
              //     //       decoration: BoxDecoration(
              //     //         borderRadius: BorderRadius.circular(0),
              //     //         color:
              //     //         orderCont.orders[orderCont.selectedDocIndex]
              //     //         ['status'] ==
              //     //             'paid' && homeController.isSessionToday
              //     //             ? Primary.primary
              //     //             : Primary.primary
              //     //             .withAlpha((0.7 * 255).toInt()),
              //     //       ),
              //     //       child: Center(
              //     //           child: Text(
              //     //             'reprint'.tr,
              //     //             style: TextStyle(fontSize: 14, color: Primary.p0),
              //     //           )),
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
        );
      }
    );
  }
}
