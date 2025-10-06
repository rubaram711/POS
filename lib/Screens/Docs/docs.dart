import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/orders_controller.dart';
import '../../../Controllers/home_controller.dart';
import '../../../Controllers/payment_controller.dart';
import '../../../Controllers/products_controller.dart';
import '../../../Widgets/loading.dart';
import '../../../Widgets/page_title.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../Widgets/table_item.dart';
import '../../../Widgets/table_title.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Controllers/client_controller.dart';
import '../../const/functions.dart';

class Docs extends StatefulWidget {
  const Docs({super.key});

  @override
  State<Docs> createState() => _DocsState();
}

class _DocsState extends State<Docs> {
  final OrdersController ordersController = Get.find();
  final HomeController homeController = Get.find();
  final ProductController productController = Get.find();
  final PaymentController paymentController = Get.find();
  final ClientController clientController = Get.find();


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
    double width = MediaQuery.of(context).size.width * 0.1;
    return GetBuilder<OrdersController>(builder: (orderCont) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              homeController.selectedTab.value = 'Home';
                            },
                            child: Icon(Icons.arrow_back,
                                size: 22,
                                // color: Colors.grey,
                                color: Primary.primary),
                          ),
                          gapW10,
                          PageTitle(text: 'orders'.tr),
                        ],
                      ),
                      gapH24,
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
                            width: MediaQuery.of(context).size.width * 0.15,
                            requestFocusOnTap: false,
                            // enableSearch: false,
                            hintText: 'all_docs'.tr,
                            inputDecorationTheme: InputDecorationTheme(
                              // filled: true,
                              hintStyle:
                                  const TextStyle(fontStyle: FontStyle.italic),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 0, 25, 5),
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
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 15),
                        decoration: BoxDecoration(
                            color: Primary.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
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
                              width: MediaQuery.of(context).size.width * 0.07,
                            ),
                            TableTitle(
                              text: 'cashing_methods'.tr,
                              width: width,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: orderCont.isOrdersFetched
                            ? ListView.builder(
                                itemCount: orderCont.orders.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    OrdersAsRowInTable(
                                      info: orderCont.orders[index],
                                      index: index,
                                    ),
                                    const Divider()
                                  ],
                                ),
                              )
                            : loading(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Others.borderColor)),
              child: orderCont.selectedDocIndex == -1
                  ? const Center(
                      child: Text('Select an order'),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.82,
                          child:
                               ListView.builder(
                                  itemCount:orderCont
                                  .selectedDoc.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      OrderItemAsRowInTable(
                                        item: orderCont.selectedDoc[index],
                                        index: index,
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                )
                              ,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tooltip(
                              message:  homeController.isSessionToday?'':'You can\'t refund before closing this session and opening a new one.',
                              child: InkWell(
                                onTap: orderCont.orders[orderCont.selectedDocIndex]
                                            ['status'] == 'paid' && homeController.isSessionToday
                                    ? () {
                                        productController.setSelectedOrderInfo(
                                            orderCont
                                                .orders[orderCont.selectedDocIndex],
                                            true);
                                        clientController.setSelectedClientOrderInfo(
                                            orderCont
                                                .orders[orderCont.selectedDocIndex]);
                                        homeController.selectedTab.value = 'Home';
                                      }
                                    : null,
                                child: Container(
                                  height: Sizes.deviceHeight * 0.12,
                                  width: Sizes.deviceWidth*0.145,
                                  // padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color:
                                        orderCont.orders[orderCont.selectedDocIndex]
                                                    ['status'] ==
                                                'paid' && homeController.isSessionToday
                                            ? Primary.primary
                                            : Primary.primary
                                                .withAlpha((0.7 * 255).toInt()),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'refund'.tr,
                                    style: TextStyle(fontSize: 14, color: Primary.p0),
                                  )),
                                ),
                              ),
                            ),
                            // gapW10,
                            Tooltip(
                              message:  homeController.isSessionToday?'':'You can\'t reprint before closing this session and opening a new one.',
                              child: InkWell(
                                onTap:  homeController.isSessionToday
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
                                  paymentController.remainingWithExchange=orderCont.orders[orderCont.selectedDocIndex]['posCurrencyRemaining'];
                                  paymentController.primaryCurrencyRemaining=orderCont.orders[orderCont.selectedDocIndex]['primaryCurrencyRemaining'];
                                  paymentController.changeWithExchange=orderCont.orders[orderCont.selectedDocIndex]['posCurrencyChange'];
                                  paymentController.primaryCurrencyChange=orderCont.orders[orderCont.selectedDocIndex]['primaryCurrencyChange'];
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
                                  homeController
                                      .setSelectedTab('print');
                                      }
                                    : null,
                                child: Container(
                                  height: Sizes.deviceHeight * 0.12,
                                  width: Sizes.deviceWidth*0.145,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color:
                                    homeController.isSessionToday
                                            ? Primary.primary
                                            : Primary.primary
                                                .withAlpha((0.7 * 255).toInt()),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'reprint'.tr,
                                    style: TextStyle(fontSize: 14, color: Primary.p0),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            )
          ],
        ),
      );
    });
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
    double width = MediaQuery.of(context).size.width * 0.1;
    return InkWell(
      onHover: (val) {
        setState(() {
          isHovered = val;
        });
      },
      onTap: () {

        ordersController.setSelectedDoc([]);
        ordersController.setSelectedDoc(widget.info['orderItems']);
        ordersController.setSelectedDocIdAndIndex(
            '${widget.info['id']}', widget.index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
            color:ordersController.selectedDocIndex==widget.index
                ?Primary.primary.withAlpha((0.2 * 255).toInt())
                :isHovered
                  ? Primary.primary.withAlpha((0.1 * 255).toInt())
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
              width: MediaQuery.of(context).size.width * 0.07,
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
                  children: [
                    Text(
                      '${widget.item['item_name'] ?? ''} ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                homeController.isTablet
                    ? Wrap(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.item['quantity']} ${'units'.tr} '
                                'x ${numberWithComma(double.parse('${widget.item['price_after_tax']}').toStringAsFixed(2))} ${productController.posCurrency}/${'units'.tr}',
                                style: const TextStyle(
                                  fontSize: 12,
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
                          ),
                          Text(
                            '${numberWithComma((   double.parse('${widget.item['price_after_tax']}')*double.parse('${widget.item['quantity']}')).toStringAsFixed(2))} ${productController.posCurrency}',
                            // '${numberWithComma((   double.parse('${widget.item['price_after_tax']}')*double.parse('${widget.item['quantity']}')).toStringAsFixed(2))} LBP',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Sizes.deviceWidth * 0.15,
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
                          ),
                          SizedBox(
                            width: Sizes.deviceWidth * 0.07,
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
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
