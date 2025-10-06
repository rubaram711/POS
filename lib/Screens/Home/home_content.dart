import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Locale_Memory/save_user_info_locally.dart';
import 'package:pos_project/Screens/Home/add_note_for_park_dialog.dart';
import 'package:pos_project/Screens/Home/payment_screen.dart';
import 'package:pos_project/Screens/Home/quantities_dialog.dart';
import 'package:pos_project/Screens/Home/zero_quantity_dialog.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import '../../Backend/CategoriesBackend/get_categories.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Backend/get_currencies.dart';
import '../../Backend/waste.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Widgets/add_customer_btn.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../../const/constants.dart';
import '../../const/functions.dart';
import '../Clients/customers_dialog.dart';
import '../MobileScreens/mobile_item_info_dialog.dart';
import 'add_discount_to_order_item_dialog.dart';
import 'barcode_scanner.dart';
import 'orders_dialog.dart';

TextEditingController searchByBarcodeOrNameController = TextEditingController();
TextEditingController searchByBarcodeController = TextEditingController();
TextEditingController noteController = TextEditingController();

ScrollController _scrollController = ScrollController();

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCustomer = '';
  bool isFilterCatClicked = false;
  // var shiftStart;
  List categoriesList = [
    {
      'category_name': 'All Menu',
    },
  ];
  bool isCategoriesFetched = false;
  getCategoriesFromBack() async {
    var p = await getCategories();
    var data =
        p.where((element) => element['category_name'] != 'STANDARD').toList();
    // setState(() {
    categoriesList.addAll(data);
    // productController.selectedCategoryId='${data[0]['id']}';
    // productController.getAllProductsFromBack();
    isCategoriesFetched = true;
    // });
  }

  ClientController clientController = Get.find();
  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();
  HomeController homeController = Get.find();
  OrdersController ordersController = Get.find();
  // ExchangeRatesController exchangeRatesController = Get.find();

  Timer? searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    await productController.getAllProductsFromBackWithSearch();
  }

  bool isSearchFieldAppear = false;

  getCurrenciesFromBackend() async {
    var p = await getCurrencies();
    if ('$p' != '[]') {
      productController.setDiscountTypesList(p['discountTypes']);
      paymentController.addToPaymentMethodList(p['cachingMethods']);
      productController.setIsDataFetched(true);
    }
  }

  getInfoFromPref() async {
    var showQuantitiesOnPos = await getShowQuantitiesOnPosFromPref();
    productController.isShowQuantitiesOnPosChecked =
        showQuantitiesOnPos == '1' ? true : false;
  }
  final ScrollController scrollControllerForGridView=ScrollController();

  @override
  void initState() {
    // start();
    // shiftStart = DateFormat('hh:mm:ss').format(DateTime.now());
    //todo
    // productController.orderItemsList={};
    // productController.selectedCategoryId='';
    // productController.isLoading = false;
    productController.productsList = [];
    productController.currentPage=1;
    // scrollControllerForGridView.addListener(() {
    //   if(scrollControllerForGridView.position.pixels>=scrollControllerForGridView.position.maxScrollExtent || !productController.isLoading){
    //     productController.getAllProductsFromBack();
    //   }
    // },);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollControllerForGridView.addListener(() {
        if (scrollControllerForGridView.position.pixels >= scrollControllerForGridView.position.maxScrollExtent &&
            !productController.isLoading) {
          productController.getAllProductsFromBack();
        }
      });
    });

    getInfoFromPref();
    getCategoriesFromBack();
    productController.getAllProductsFromBack();
    clientController.selectedCustomerId = '-1';
    clientController.selectedCustomerIdWithOk = '-1';
    clientController.selectedCustomerObject = {};
    // getInfoFromPref();
    getCurrenciesFromBackend();
    // checkIfCashAvailable();
    super.initState();
  }

  bool isClickedQuantity = false;
  bool isClickedPrice = false;
  bool isClickedRetrieve = false;
  // bool isClickedPark = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (proCont) {
      return Container(
        margin: const EdgeInsets.only(right: 20, top: 15, left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 13,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<ClientController>(
                        builder: (cont) {
                          return AddCustomerBtn(
                            onTapFunction: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(9)),
                                        ),
                                        elevation: 0,
                                        content: CustomersDialog(),
                                      ));
                            },
                            text: cont.selectedCustomerIdWithOk == '-1'
                                ? 'cash_customer'.tr
                                : cont.selectedCustomerObject['name'],
                            icon: Icons.person,
                            color: Primary.primary,
                            textColor: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.1,
                          );
                        }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: DialogTextFieldWithoutText(
                              // hint: 'search_by'.tr,
                              hint: 'scan_barcode'.tr,
                              textEditingController: searchByBarcodeController,
                              textFieldWidth: homeController.isTablet
                                  ? MediaQuery.of(context).size.width * 0.7
                                  : MediaQuery.of(context).size.width * 0.25,
                              validationFunc: (value) {},
                              onIconClickedFunc: () {
                                // Get.to(()=>const CameraScannerPage());
                                // homeController.selectedTab.value =
                                //     'camera_scanner_page';
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const BarcodeScannerPage();
                                }));
                              },
                              onCloseIconClickedFunc: () {},
                              onChangedFunc: (val) async {
                                const duration = Duration(
                                    milliseconds:
                                        800); // set the duration that you want call search() after that.
                                if (searchOnStoppedTyping != null) {
                                  setState(() => searchOnStoppedTyping!
                                      .cancel()); // clear timer
                                }
                                setState(() => searchOnStoppedTyping =
                                        Timer(duration, () async {
                                      await productController
                                          .getAllProductsFromBackWithSearch();
                                      if (proCont.productsList.length == 1) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (_scrollController.hasClients) {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 1),
                                            );
                                          }
                                        });
                                        String id =
                                            '${proCont.productsList[0]['id']}';
                                        double tax = proCont.productsList[0]
                                                ['taxation'] /
                                            100.0;
                                        // double usdPrice = 0.0,
                                        //     otherCurrencyPrice = 0.0;
                                        // var priceCurrency = proCont.productsList[0]['priceCurrency']['name'];
                                        var resultForPrice =  proCont.productsList[0]['priceCurrency']['latest_rate'].isEmpty?'1':proCont.productsList[0]['priceCurrency']['latest_rate'];
                                        var showPriceLatestRate =
                                        resultForPrice != null ? '$resultForPrice' : '1';
                                        var price = double.parse('${proCont.productsList[0]['unitPrice']}');
                                        // var showInCardCurrencyPrice = double.parse(
                                        //     '${Decimal.parse('$price') * Decimal.parse('$productLatestRate')}');

                                        var rateToPos = calculateRateCur1ToCur2(
                                            double.parse(showPriceLatestRate), double.parse(productController.posCurrencyLatestRate));
                                        var showInPosCurrencyPrice=double.parse(
                                            '${Decimal.parse('$price') * Decimal.parse(rateToPos)}');
                                        price=roundUp(price, 2);
                                        showInPosCurrencyPrice=roundUp(showInPosCurrencyPrice, 2);
                                        Map p = {
                                          'id': proCont.productsList[0]['id'],
                                          'item_name': proCont.productsList[0]
                                              ['item_name'],
                                          'quantity': '1',
                                          'tax': tax,
                                          'percent_tax': proCont.productsList[0]
                                              ['taxation'],
                                          'discount': 0,
                                          'discount_percent': 0,
                                          'discount_type_id': '',
                                          'original_price':
                                              price, //widget.product['unitPrice'],
                                          'price':
                                              '$showInPosCurrencyPrice', // widget.product['unitPrice'],
                                          'UnitPrice': price, // widget.product['unitPrice'],
                                          'final_price':
                                          showInPosCurrencyPrice, // widget.product['unitPrice'],
                                          'symbol': proCont.productsList[0]
                                                  ['posCurrency']['symbol'] ??
                                              '',
                                          'sign':
                                              proCont.isReturnClicked ? '-' : ''
                                        };
                                        if(homeController.isSessionToday){
                                        proCont.addToOrderItemsList(id, p);
                                        proCont.calculateSummary();}
                                      }
                                    }));
                              },
                              radius: 9,
                            ),
                          ),
                          // gapW10,
                          isSearchFieldAppear
                              ? Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: DialogTextFieldWithoutText(
                                    hint: 'search_with_close'.tr,
                                    textEditingController:
                                        searchByBarcodeOrNameController,
                                    textFieldWidth: homeController.isTablet
                                        ? MediaQuery.of(context).size.width *
                                            0.35
                                        : MediaQuery.of(context).size.width *
                                            0.15,
                                    validationFunc: (value) {},
                                    onIconClickedFunc: () {},
                                    onCloseIconClickedFunc: () {
                                      setState(() {
                                        searchByBarcodeOrNameController.clear();
                                        productController
                                            .getAllProductsFromBackWithSearch();
                                        isSearchFieldAppear = false;
                                      });
                                    },
                                    onChangedFunc: (val) {
                                      _onChangeHandler(val);
                                    },
                                    radius: 9,
                                  ),
                                )
                              : const SizedBox(),
                          isSearchFieldAppear
                              ? const SizedBox()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSearchFieldAppear = true;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    size: 20,
                                  )),
                          gapW20,
                        ],
                      ),
                    ],
                  ),
                  Container(
                      height: 85,
                      padding: const EdgeInsets.fromLTRB(0, 24, 10, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 9,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoriesList.length,
                              itemBuilder: (context, index) => _categoryCard(
                                  title: categoriesList[index]['category_name'],
                                  index: index,
                                  id: '${categoriesList[index]['id'] ?? '0'}'),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: Sizes.deviceHeight * 0.68,
                    child:
                    proCont.isDataFetched
                        ?
                    GridView.count(
                      controller: scrollControllerForGridView,
                            crossAxisCount: homeController.isTablet ? 3 : 5,
                            childAspectRatio: homeController.isTablet
                                ? (Sizes.deviceWidth *
                                    0.6 /
                                    Sizes.deviceHeight *
                                    1.0)
                                : (Sizes.deviceWidth *
                                    0.4 /
                                    Sizes.deviceHeight *
                                    0.9),
                            children: List.generate(proCont.productsList.length,
                                (index) {
                              return ItemCard(
                                product: proCont.productsList[index],
                                index: index,
                              );
                            }),
                          )
                        : SizedBox(),
                  ),
                  if(productController.isLoading)Padding(padding: EdgeInsets.all(0),child: CircularProgressIndicator(),)
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  gapH4,
                  Column(
                    children: [
                      ReusableButtonWithIcon(
                          height: 75,
                          isClicked: isClickedQuantity,
                          width: MediaQuery.of(context).size.width,
                          // width: homeController.isTablet
                          //     ? Sizes.deviceWidth * 0.07
                          //     : Sizes.deviceWidth * 0.05,
                          btnText: '',
                          onTapFunction: () {
                            if (proCont.selectedOrderItemId != '') {
                              setState(() {
                                isClickedQuantity = !isClickedQuantity;
                                isClickedPrice = false;
                              });
                              //todo
                              // proCont
                              //     .setIsLineDiscountSelected(true);
                              // showDialog<String>(
                              //     context: context,
                              //     builder: (BuildContext context) =>
                              //     const AlertDialog(
                              //         backgroundColor: Colors.white,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //           BorderRadius.all(
                              //               Radius.circular(9)),
                              //         ),
                              //         elevation: 0,
                              //         content:
                              //         AddDiscountToOrderItemDialog()));
                            } else {
                              // CommonWidgets.snackBar('error', 'You have to choose the item you want to apply the discount to');
                            }
                          },
                          radius: 0,
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.boxes,
                              //   color: Others.btnIconColor,
                              //   size: 30,
                              // ),
                              Image.asset(
                                'assets/images/boxes.png',
                                height: 30,
                                width: 30,
                              ),
                              Text(
                                'quantity'.tr,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              )
                            ],
                          )),
                      ReusableButtonWithIcon(
                          height: 75,
                          isClicked: isClickedPrice,
                          width: MediaQuery.of(context).size.width,
                          // width: homeController.isTablet
                          //     ? Sizes.deviceWidth * 0.07
                          //     : Sizes.deviceWidth * 0.05,
                          btnText: '',
                          onTapFunction: () {
                            if (proCont.selectedOrderItemId != '') {
                              setState(() {
                                isClickedPrice = !isClickedPrice;
                                isClickedQuantity = false;
                              });
                            } else {
                              // CommonWidgets.snackBar('error', 'You have to choose the item you want to apply the discount to');
                            }
                          },
                          radius: 0,
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/price-tag.png',
                                height: 30,
                                width: 30,
                              ),
                              Text(
                                'price'.tr,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              )
                            ],
                          )),
                      proCont.isWasteClicked || !homeController.isSessionToday
                          ? Tooltip(
                              message:homeController.isSessionToday?
                                  'You can\'t return products when you click waste':'You can\'t return a product before closing this session and opening a new one.',
                              child: ReusableButtonWithIcon(
                                  height: 75,
                                  isClicked: proCont.isReturnClicked,
                                  width: MediaQuery.of(context).size.width,
                                  btnText: '',
                                  onTapFunction: () {},
                                  radius: 0,
                                  childWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/return.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      Text(
                                        'return'.tr,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      )
                                    ],
                                  )),
                            )
                          : ReusableButtonWithIcon(
                              height: 75,
                              isClicked: proCont.isReturnClicked,
                              width: MediaQuery.of(context).size.width,
                              btnText: '',
                              onTapFunction: () async {
                                proCont.setIsReturnClicked(
                                    !proCont.isReturnClicked);
                                if (proCont.selectedOrderItemId != '') {
                                  proCont.orderItemsList[proCont
                                      .selectedOrderItemId]['sign'] = '-';
                                }
                                proCont.calculateSummary();
                              },
                              radius: 0,
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/return.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  Text(
                                    'return'.tr,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  )
                                ],
                              )),
                      Tooltip(
                        message:
                        proCont.selectedOrderItemId.isEmpty && homeController.isSessionToday?'Select an item first':'',
                        child: ReusableButtonWithIcon(
                            height: 75,
                            isClicked: false,
                            width: MediaQuery.of(context).size.width,
                            btnText: '',
                            onTapFunction: () {
                              if (proCont.orderItemsList.isNotEmpty) {
                                proCont.setIsLineDiscountSelected(false);
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9)),
                                            ),
                                            elevation: 0,
                                            content:
                                                AddDiscountToOrderItemDialog()));
                              }
                            },
                            radius: 0,
                            childWidget: Icon(
                              Icons.percent,
                              color: Others.btnIconColor,
                              size: 30,
                            )),
                      ),
                Tooltip(
                    message:
                    proCont.selectedOrderItemId.isEmpty && homeController.isSessionToday?'Select an item from your order list':'',
                        child: ReusableButtonWithIcon(
                            height: 75,
                            isClicked: false,
                            width: MediaQuery.of(context).size.width,
                            // width: homeController.isTablet
                            //     ? Sizes.deviceWidth * 0.07
                            //     : Sizes.deviceWidth * 0.05,
                            btnText: '',
                            onTapFunction: () {
                              if (proCont.selectedOrderItemId != '') {
                                proCont.setIsLineDiscountSelected(true);
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9)),
                                            ),
                                            elevation: 0,
                                            content:
                                                AddDiscountToOrderItemDialog()));
                              } else {
                                // CommonWidgets.snackBar('error', 'You have to choose the item you want to apply the discount to');
                              }
                            },
                            radius: 0,
                            childWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.percent,
                                  color: Others.btnIconColor,
                                  size: 30,
                                ),
                                Text(
                                  'line'.tr,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Column(
                    children: [
                      ReusableButtonWithIcon(
                        height: 75,
                        isClicked: isClickedRetrieve,
                        width: MediaQuery.of(context).size.width,
                        // width: homeController.isTablet
                        //     ? Sizes.deviceWidth * 0.07
                        //     : Sizes.deviceWidth * 0.05,
                        btnText: '',
                        onTapFunction: () async {
                          setState(() {
                            isClickedRetrieve = true;
                          });
                          proCont.setIsLineDiscountSelected(true);
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9)),
                                      ),
                                      elevation: 0,
                                      content: OrdersDialog()));
                          setState(() {
                            isClickedRetrieve = false;
                          });
                        },
                        radius: 0,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'retrieve'.tr,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Primary.primary,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      !homeController.isSessionToday || proCont.isWasteClicked || !proCont.isCashAvailable
                          ?Tooltip(
                        message:
                        !homeController.isSessionToday
                            ?'You can\'t park a new order before closing this session and opening a new one.'
                        :proCont.isWasteClicked
                            ?'You can\'t park when you click waste'
                            :'Open Cash Tray First',
                           child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 75,
                            decoration: BoxDecoration(
                              color:Others.btnColor,
                              border: Border.all(
                                color: Primary.p0,
                              ),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'park'.tr,
                                      style: TextStyle(
                                          color: Primary.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  ],
                                )
                            ),
                                                    ),

                          ):ReusableButtonWithIcon(
                        height: 75,
                        isClicked: proCont.isClickedPark,
                        width: MediaQuery.of(context).size.width,
                        // width: homeController.isTablet
                        //     ? Sizes.deviceWidth * 0.07
                        //     : Sizes.deviceWidth * 0.05,
                        btnText: '',
                        onTapFunction: () async {
                          if (proCont.orderItemsList.isNotEmpty) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    const AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9)),
                                        ),
                                        elevation: 0,
                                        content: EnterNoteDialog()));
                          }
                        },
                        radius: 0,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'park'.tr,
                              style: TextStyle(
                                  color: Primary.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ),
                   homeController.isSessionToday?ReusableButtonWithIcon(
                        height: 75,
                        isClicked: proCont.isWasteClicked,
                        width: MediaQuery.of(context).size.width,
                        // width: homeController.isTablet
                        //     ? Sizes.deviceWidth * 0.07
                        //     : Sizes.deviceWidth * 0.05,
                        btnText: '',
                        onTapFunction: () async {
                          proCont.setIsWasteClicked(!proCont.isWasteClicked);
                        },
                        radius: 0,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'waste'.tr,
                              style: TextStyle(
                                  color: Primary.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ):Tooltip(
                     message: 'You can\'t waste before closing this session and opening a new one.',
                        child: Container(
                                             width: MediaQuery.of(context).size.width,
                                             height: 75,
                                             decoration: BoxDecoration(
                         color:Others.btnColor,
                         border: Border.all(
                           color: Primary.p0,
                         ),
                         borderRadius: BorderRadius.circular(0),
                                             ),
                                             child: Center(
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                 'waste'.tr,
                                 style: TextStyle(
                                     color: Primary.primary,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 12),
                               )
                             ],
                           )
                                             ),
                                           ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: GetBuilder<ProductController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'total_items'.tr} (${controller.orderItemsList.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 4, vertical: 1),
                          //       decoration: BoxDecoration(
                          //         color: Primary.primary,
                          //         borderRadius:
                          //             const BorderRadius.all(Radius.circular(0)),
                          //       ),
                          //       child: InkWell(
                          //         highlightColor: Colors.white,
                          //         onTap: () {
                          //           // if(controller.orderItemsList[controller.selectedOrderItemId]['quantity']>1){
                          //           controller.orderItemsList[
                          //                   controller.selectedOrderItemId]
                          //               ['quantity'] = controller.orderItemsList[
                          //                       controller.selectedOrderItemId]
                          //                   ['quantity'] -
                          //               1;
                          //
                          //           controller.orderItemsList[controller
                          //                   .selectedOrderItemId]['final_price'] =
                          //               controller.orderItemsList[controller
                          //                       .selectedOrderItemId]['price'] *
                          //                   controller.orderItemsList[controller
                          //                       .selectedOrderItemId]['quantity'];
                          //
                          //           controller.calculateSummary();
                          //           // }
                          //         },
                          //         child: Row(
                          //           children: [
                          //             Text(
                          //               'qty'.tr,
                          //               style: const TextStyle(
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white
                          //                   // fontSize:
                          //                   ),
                          //             ),
                          //             const Icon(
                          //               Icons.remove,
                          //               size: 14,
                          //               color: Colors.white,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: Sizes.deviceWidth * 0.015),
                          //     Container(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 4, vertical: 1),
                          //       decoration: BoxDecoration(
                          //         color: Primary.primary,
                          //         borderRadius:
                          //             const BorderRadius.all(Radius.circular(0)),
                          //       ),
                          //       child: InkWell(
                          //         highlightColor: Colors.white,
                          //         onTap: () {
                          //           // if (controller.orderItemsList[controller
                          //           //         .selectedOrderItemId]['quantity'] <
                          //           //     productsList[
                          //           //             controller.selectedOrderItemIndex]
                          //           //         ['current_quantity']) {
                          //             controller.orderItemsList[controller
                          //                     .selectedOrderItemId]['quantity'] =
                          //                 controller.orderItemsList[controller
                          //                             .selectedOrderItemId]
                          //                         ['quantity'] + 1;
                          //             controller.orderItemsList[
                          //                     controller.selectedOrderItemId]
                          //                 ['final_price'] = controller
                          //                             .orderItemsList[
                          //                         controller.selectedOrderItemId]
                          //                     ['price'] *
                          //                 controller.orderItemsList[controller
                          //                     .selectedOrderItemId]['quantity'];
                          //
                          //             controller.calculateSummary();
                          //           // } else {
                          //           //   CommonWidgets.snackBar(
                          //           //       'error', 'sold_out'.tr);
                          //           // }
                          //           // double tax =productsList[controller.selectedOrderItemIndex]['unitPrice'] *productsList[controller.selectedOrderItemIndex]['taxation']/100.0;
                          //           // if (controller.orderItemsQuantities[productsList[controller.selectedOrderItemIndex]['id']] <
                          //           //     productsList[controller.selectedOrderItemIndex]['quantity']) {
                          //           //       controller.addToOrderItemsQuantities(
                          //           //       productsList[controller.selectedOrderItemIndex]['id'],
                          //           //       controller.orderItemsQuantities[productsList[controller.selectedOrderItemIndex]['id']] +1);
                          //           //       controller.increaseTotal(productsList[controller.selectedOrderItemIndex]['unitPrice']+tax) ;
                          //           // }
                          //         },
                          //         child: Row(
                          //           children: [
                          //             Text(
                          //               'qty'.tr,
                          //               style: const TextStyle(
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white
                          //                   // fontSize:
                          //                   ),
                          //             ),
                          //             const Icon(
                          //               Icons.add,
                          //               size: 14,
                          //               color: Colors.white,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: Sizes.deviceWidth * 0.015),
                          //   ],
                          // )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                controller.orderItemsList.keys.toList().length,
                            itemBuilder: (context, index) {
                              var keys =
                                  controller.orderItemsList.keys.toList();
                              return _orderItem(
                                controller.orderItemsList[keys[index]],
                              );
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Sizes.deviceHeight * 0.01),
                        height: 2,
                        width: double.infinity,
                        child: const Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Sizes.deviceHeight * 0.31,
                            width:Sizes.deviceWidth*0.16,// 250,
                            child: GridView.count(
                              crossAxisCount: 3, // 3,
                              childAspectRatio: (Sizes.deviceWidth *
                                      0.7 /
                                      Sizes.deviceHeight *
                                      1.1
                                  //1.72
                                  ),
                              children: List.generate(
                                  calculatorNumbersInHome.length, (index) {
                                return ReusableCalculatorBtn(
                                    isEnable:
                                        (isClickedQuantity || isClickedPrice),
                                    onTapFunction: () async {
                                      if (isClickedQuantity)
                                      {
                                        var isAllowedToSellZero =
                                            await getIsAllowedToSellZeroFromPref();
                                        var cantSellZeroMessage =
                                            await getCantSellZeroMessageFromPref();
                                        if (calculatorNumbersInHome[index] ==
                                            '-/+') {
                                          if (controller.orderItemsList[
                                                      controller
                                                          .selectedOrderItemId]
                                                  ['sign'] ==
                                              '-') {
                                            controller.orderItemsList[controller
                                                    .selectedOrderItemId]
                                                ['sign'] = '';
                                          } else {
                                            controller.orderItemsList[controller
                                                    .selectedOrderItemId]
                                                ['sign'] = '-';
                                          }
                                        }
                                        if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].contains(calculatorNumbersInHome[index]) &&
                                            (controller.orderItemsList[controller.selectedOrderItemId]
                                                        ['quantity'] ==
                                                    '0' ||
                                                controller.isFirstClick[controller.selectedOrderItemId] ==
                                                    true)) {
                                          if (controller.orderItemsList[controller
                                                          .selectedOrderItemId]
                                                      ['sign'] !=
                                                  '-' &&
                                              !isAllowedToSellZero &&
                                              double.parse(controller
                                                              .orderItemsList[
                                                          controller
                                                              .selectedOrderItemId]
                                                      ['available_qty']) <
                                                  double.parse(
                                                      '${controller.orderItemsList[controller.selectedOrderItemId]['sign']}${calculatorNumbersInHome[index]}')) {
                                            CommonWidgets.snackBar(
                                                'error',
                                                cantSellZeroMessage.isNotEmpty
                                                    ? cantSellZeroMessage
                                                    : 'you can not sell zero quantity');
                                          } else {
                                            controller
                                                .setQuantityOfItemINOrderList(
                                                    controller
                                                        .selectedOrderItemId,
                                                    calculatorNumbersInHome[
                                                        index]);
                                          }
                                          controller.setIsFirstClickVal(
                                              controller.selectedOrderItemId,
                                              false);
                                        } else if ([
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
                                            ].contains(calculatorNumbersInHome[
                                                index]) &&
                                            controller.orderItemsList[controller.selectedOrderItemId]
                                                    ['quantity'] !=
                                                '0') {
                                          if (controller.orderItemsList[controller
                                                          .selectedOrderItemId]
                                                      ['sign'] !=
                                                  '-' &&
                                              !isAllowedToSellZero &&
                                              double.parse(controller
                                                              .orderItemsList[
                                                          controller
                                                              .selectedOrderItemId]
                                                      ['available_qty']) <
                                                  double.parse(
                                                      '${controller.orderItemsList[controller.selectedOrderItemId]['sign']}${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}${calculatorNumbersInHome[index]}')) {
                                            CommonWidgets.snackBar(
                                                'error', cantSellZeroMessage);
                                          } else {
                                            controller.setQuantityOfItemINOrderList(
                                                controller.selectedOrderItemId,
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}${calculatorNumbersInHome[index]}');
                                          }
                                        } else if (calculatorNumbersInHome[index] ==
                                            '⌫') {
                                          if ('${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}'
                                                  .length ==
                                              1) {
                                            controller
                                                .setQuantityOfItemINOrderList(
                                                    controller
                                                        .selectedOrderItemId,
                                                    '0');
                                          } else {
                                            String txt =
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}'
                                                    .substring(
                                                        0,
                                                        '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}'
                                                                .length -
                                                            1);
                                            controller
                                                .setQuantityOfItemINOrderList(
                                                    controller
                                                        .selectedOrderItemId,
                                                    txt);
                                          }
                                        } else if (calculatorNumbersInHome[index] == '.' &&
                                            !'${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}'
                                                .contains('.')) {
                                          controller.setQuantityOfItemINOrderList(
                                              controller.selectedOrderItemId,
                                              '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}.');
                                        }
                                        controller.orderItemsList[
                                                controller.selectedOrderItemId]
                                            ['final_price'] = double.parse(
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['price']}') *
                                            double.parse(
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}');

                                        controller.orderItemsList[controller.selectedOrderItemId]['price']=roundUp(controller.orderItemsList[controller.selectedOrderItemId]['price'], 2);
                                        controller.orderItemsList[
                                        controller.selectedOrderItemId]['final_price']=roundUp(controller.orderItemsList[
                                        controller.selectedOrderItemId]['final_price'], 2);

                                        controller.calculateSummary();
                                      } else if (isClickedPrice) {
                                        if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].contains(calculatorNumbersInHome[index]) &&
                                            (controller.orderItemsList[controller.selectedOrderItemId]
                                                        ['price'] ==
                                                    '0' ||
                                                controller.isFirstClick[controller.selectedOrderItemId] ==
                                                    true)) {
                                          controller.setPriceOfItemINOrderList(
                                              controller.selectedOrderItemId,
                                              calculatorNumbersInHome[index]);
                                          controller.setIsFirstClickVal(
                                              controller.selectedOrderItemId,
                                              false);
                                        } else if ([
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
                                            ].contains(calculatorNumbersInHome[
                                                index]) &&
                                            controller.orderItemsList[controller.selectedOrderItemId]
                                                    ['price'] !=
                                                '0') {
                                          controller.setPriceOfItemINOrderList(
                                              controller.selectedOrderItemId,
                                              '${controller.orderItemsList[controller.selectedOrderItemId]['price']}${calculatorNumbersInHome[index]}');
                                        } else if (calculatorNumbersInHome[index] ==
                                            '⌫') {
                                          if ('${controller.orderItemsList[controller.selectedOrderItemId]['price']}'
                                                  .length ==
                                              1) {
                                            controller
                                                .setPriceOfItemINOrderList(
                                                    controller
                                                        .selectedOrderItemId,
                                                    '0');
                                          } else {
                                            String txt =
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['price']}'
                                                    .substring(
                                                        0,
                                                        '${controller.orderItemsList[controller.selectedOrderItemId]['price']}'
                                                                .length -
                                                            1);
                                            controller
                                                .setPriceOfItemINOrderList(
                                                    controller
                                                        .selectedOrderItemId,
                                                    txt);
                                          }
                                        } else if (calculatorNumbersInHome[index] == '.' &&
                                            !'${controller.orderItemsList[controller.selectedOrderItemId]['price']}'
                                                .contains('.')) {
                                        }
                                        controller.orderItemsList[
                                                controller.selectedOrderItemId]
                                            ['final_price'] = double.parse(
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['price']}') *
                                            double.parse(
                                                '${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}');
                                        controller.orderItemsList[controller.selectedOrderItemId]['price']=roundUp(double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['price']}'), 2).toString();
                                        controller.orderItemsList[
                                        controller.selectedOrderItemId]['final_price']=roundUp(controller.orderItemsList[
                                        controller.selectedOrderItemId]['final_price'], 2);
                                        controller.calculateSummary();

                                      }
                                    },
                                    tabletFontSize: 25,
                                    fontSize: 25,
                                    text: calculatorNumbersInHome[index]);
                              }),
                            ),
                          ),
                          SizedBox(
                            height: Sizes.deviceHeight * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          homeController.isTablet ? 0 : 5.0),
                                  child: Table(
                                    border:
                                        TableBorder.all(color: Colors.white),
                                    columnWidths: {
                                      0: FixedColumnWidth(
                                          Sizes.deviceWidth * 0.05),
                                      1: FixedColumnWidth(
                                          Sizes.deviceWidth * 0.03),
                                      2: FixedColumnWidth(
                                          Sizes.deviceWidth * 0.09),
                                    },
                                    children:
                                    controller.primaryCurrency==controller.posCurrency
                                        && homeController.companySubjectToVat=='1'
                                        ?[
                                        TableRow(children: [
                                        Text(
                                        '${'total'.tr}:',
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        Text(
                                        controller.posCurrency,
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        Text(
                                        controller.isWasteClicked
                                        ? '0'
                                            : numberWithComma(controller
                                            .totalPrice.toString()),
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        ]),
                                        TableRow(children: [
                                        const Text(
                                        '${'Vat'}:',
                                        // style: TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        // ),
                                        ),
                                        Text(
                                        controller.posCurrency,
                                        ),
                                        Text(
                                        controller.isWasteClicked
                                        ? '0'
                                            : numberWithComma(controller
                                            .taxesSum
                                            .toString()),
                                        ),
                                        ]),
                                        TableRow(children: [
                                        Text(
                                        '${'disc'.tr}:',
                                        ),
                                        Text(controller.posCurrency),
                                        Text(
                                        controller.isWasteClicked ||
                                        controller
                                            .orderItemsList.isEmpty
                                        ? '0'
                                            : numberWithComma(
                                        (controller.totalDiscount)
                                            .toString()),
                                        ),
                                        ]),
                                        ]
                                        : controller.primaryCurrency==controller.posCurrency
                  && homeController.companySubjectToVat != '1'?
                                    [
                                        TableRow(children: [
                                        Text(
                                        '${'total'.tr}:',
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        Text(
                                        controller.posCurrency,
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        Text(
                                        controller.isWasteClicked
                                        ? '0'
                                            : numberWithComma(controller
                                            .totalPrice
                                            .toString()),
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                        ),
                                        ]),
                                        TableRow(children: [
                                        Text(
                                        '${'disc'.tr}:',
                                        ),
                                        Text(controller.posCurrency),
                                        Text(
                                        controller.isWasteClicked ||
                                        controller
                                            .orderItemsList.isEmpty
                                        ? '0'
                                            : numberWithComma(
                                        (controller.totalDiscount)
                                            .toString()),
                                        ),
                                        ]),
                                        ]
                                        :
                                    controller.primaryCurrency!=controller.posCurrency  && homeController.companySubjectToVat!='1'
                                    ?[
                                      TableRow(children: [
                                        Text(
                                          '${'total'.tr}:',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.posCurrency,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                                  .totalPrice
                                                  .toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        const Text(
                                          '',
                                        ),
                                        Text(
                                          controller.primaryCurrency,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                                  .totalPriceWithExchange
                                                  .toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          '${'disc'.tr}:',
                                        ),
                                        Text(controller.posCurrency),
                                        Text(
                                          controller.isWasteClicked ||
                                                  controller
                                                      .orderItemsList.isEmpty
                                              ? '0'
                                              : numberWithComma(
                                                  (controller.totalDiscount)
                                                      .toString()),
                                        ),
                                      ]),
                                    ]:[
                                      TableRow(children: [
                                        Text(
                                          '${'total'.tr}:',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.posCurrency,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                              .totalPrice
                                              .toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        const Text(
                                          '',
                                        ),
                                        Text(
                                          controller.primaryCurrency,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                              .totalPriceWithExchange
                                              .toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        const Text(
                                          '${'Vat'}:',
                                          // style: TextStyle(
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                                        Text(
                                          controller.posCurrency,
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                              .taxesSum
                                              .toString()),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        const Text(
                                          '',
                                        ),
                                        Text(
                                          controller.primaryCurrency,
                                        ),
                                        Text(
                                          controller.isWasteClicked
                                              ? '0'
                                              : numberWithComma(controller
                                              .taxesSumWithExchange
                                              .toString()),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          '${'disc'.tr}:',
                                        ),
                                        Text(controller.posCurrency),
                                        Text(
                                          controller.isWasteClicked ||
                                              controller
                                                  .orderItemsList.isEmpty
                                              ? '0'
                                              : numberWithComma(
                                              (controller.totalDiscount)
                                                  .toString()),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      controller.isWasteClicked
                                          ? Tooltip(
                                              message: controller
                                                      .orderItemsList.isEmpty
                                                  ? 'Select An Item To Waste First'
                                                  : 'Click Here To Send Waste Order',
                                              child: InkWell(
                                                onTap: controller.orderItemsList
                                                        .isNotEmpty
                                                    ? () async {
                                                        var currentSessionId =
                                                            '';
                                                        var session =
                                                            await getOpenSessionId();
                                                        if ('${session['data']}' !=
                                                            '[]') {
                                                          currentSessionId =
                                                              '${session['data']['session']['id']}';
                                                        }
                                                        var p = await waste(
                                                            controller
                                                                .orderItemsList,
                                                            currentSessionId);
                                                        if (p['success'] ==
                                                            true) {
                                                          CommonWidgets
                                                              .snackBar(
                                                                  'success',
                                                                  p['message']);
                                                          // proCont.calculateSubTotal();
                                                          homeController
                                                              .setSelectedTab('print_waste');
                                                          // proCont.resetAll();
                                                        } else {
                                                          CommonWidgets
                                                              .snackBar('error',
                                                                  p['message']);
                                                        }
                                                      }
                                                    : null,
                                                child: Container(
                                                  // padding: EdgeInsets.all(5),
                                                  width: homeController.isTablet
                                                      ? Sizes.deviceWidth * 0.07
                                                      : Sizes.deviceWidth *
                                                          0.05,
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                            .orderItemsList
                                                            .isNotEmpty
                                                        ? Primary.primary
                                                        : Primary.primary
                                                            .withAlpha(
                                                                (0.7 * 255)
                                                                    .toInt()),
                                                    border: Border.all(
                                                      color: Primary.p0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'ok'.tr.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              homeController
                                                                      .isTablet
                                                                  ? 13
                                                                  : 14,
                                                          color: Primary.p0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : proCont.isCashAvailable
                                              ? Tooltip(
                                                  message: controller
                                                          .orderItemsList
                                                          .isEmpty
                                                      ? 'Select An Item To Sell First'
                                                      : '',
                                                  child: InkWell(
                                                    onTap: controller
                                                            .orderItemsList
                                                            .isNotEmpty
                                                        ? () {
                                                            homeController
                                                                    .selectedTab
                                                                    .value =
                                                                'payment';
                                                          }
                                                        : null,
                                                    child: Container(
                                                      // padding: EdgeInsets.all(5),
                                                      width: homeController.isTablet
                                                          ? Sizes.deviceWidth *
                                                              0.07
                                                          : Sizes.deviceWidth *
                                                              0.05,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                                .orderItemsList
                                                                .isNotEmpty
                                                            ? Primary.primary
                                                            : Primary.primary
                                                                .withAlpha((0.7 *
                                                                        255)
                                                                    .toInt()),
                                                        border: Border.all(
                                                          color: Primary.p0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'cash'
                                                              .tr
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  homeController
                                                                          .isTablet
                                                                      ? 13
                                                                      : 14,
                                                              color:
                                                                  Primary.p0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Tooltip(
                                                  message:
                                                  homeController.isSessionToday? 'Open Cash Tray First':'You can\'t create a new order before closing this session and opening a new one.',
                                                  child: Container(
                                                    // padding: EdgeInsets.all(5),
                                                    width: homeController.isTablet
                                                        ? Sizes.deviceWidth *
                                                            0.07
                                                        : Sizes.deviceWidth *
                                                            0.05,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color: Primary.primary
                                                          .withAlpha((0.7 * 255)
                                                              .toInt()),
                                                      border: Border.all(
                                                        color: Primary.p0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'cash'.tr.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                homeController
                                                                        .isTablet
                                                                    ? 13
                                                                    : 14,
                                                            color: Primary.p0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _orderItem(Map product) {
    return GetBuilder<ProductController>(builder: (controller) {
      // double tax=product['unitPrice'] *
      //     (product['taxation'] / 100.0);
      return InkWell(
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
          decoration: '${product['id']}' == controller.selectedOrderItemId
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                )
              : const BoxDecoration(),
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
                          '${product['item_name'] ?? ''} ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    //Text(
                    //                 widget.product['posCurrency'] != null
                    //                     ? ' ${
                    //                     widget.product['posCurrency']['symbol']=='\$'?usdPrice:otherCurrencyPrice
                    //                     // numberWithComma('${widget.product['unitPrice']?? ''}' )
                    //                      }'
                    //                     '${ ' ${widget.product['posCurrency']['symbol'] ?? ''}' }': '',
                    //               ),
                    controller.isWasteClicked
                        ? Row(
                            children: [
                              Text(
                                '${product['quantity']} ${'units'.tr}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        : homeController.isTablet
                            ? Wrap(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${product['sign'] ?? ''}${product['quantity']} ${'units'.tr} '
                                        'x ${
                                        numberWithComma(double.parse(product['price']).toString())
                                        // } ${product['symbol'] ??''}/${'units'.tr}',
                                        } ${controller.posCurrency}/${'units'.tr}',
                                        // '${controller.orderItemsQuantities[product['id']]} ${'units'.tr} '
                                        //     'x ${product['unitPrice']+tax} ${product['priceCurrency']['symbol']}/${'units'.tr}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      // controller.discountValuesMap.containsKey(product['id'])
                                      product['discount_percent'] != 0
                                          ? Text(
                                              '     W/ ${product['discount_percent']}%',
                                              // 'W/ ${controller.discountValuesMap[product['id']]}${'discount'.tr}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  Text(
                                    '${product['sign'] ?? ''}${numberWithComma(product['final_price'].toString())} ${controller.posCurrency}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Sizes.deviceWidth * 0.15,
                                        child: Text(
                                          '${product['sign'] ?? ''}${product['quantity']} ${'units'.tr} '
                                          'x ${
                                          numberWithComma(double.parse(product['price']).toString())
                                          } ${controller.posCurrency}/${'units'.tr}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      // controller.discountValuesMap.containsKey(product['id'])
                                      product['discount_percent'] != 0
                                          ? Text(
                                              '     W/ ${product['discount_percent']}%',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  SizedBox(
                                    width: Sizes.deviceWidth * 0.07,
                                    child: Text(
                                      '${product['sign'] ?? ''}${numberWithComma(product['final_price'].toString())} ${controller.posCurrency}',
                                      // '${(product['unitPrice']+tax) * controller.orderItemsQuantities[product['id']]} ${product['priceCurrency']['symbol']}',
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
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.selectedOrderItemId ==
                          '${product['id']}') {
                        controller.setSelectedOrderItemId('');
                        setState(() {
                          isClickedQuantity = false;
                          isClickedPrice = false;
                        });
                      }
                      controller.removeFromOrderItemsList('${product['id']}');
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
            ],
          ),
        ),
      );
    });
  }

  int selectedMenuIndex = 0;
  int hoveredCategoryIndex = -1;
  Widget _categoryCard(
      {required String title, required int index, required String id}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          // selectedCategoryId = id;
        });
        productController.setSelectedCategoryId(id);
        productController.getAllProductsFromBackWithSearch();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: const Color(0xff1f2029),
          border: selectedMenuIndex == index
              ? Border.all(color: Primary.primary, width: 1)
              : hoveredCategoryIndex == index
                  ? Border.all(color: Colors.white, width: 1)
                  : Border.all(
                      color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                      width: 1),
          color: selectedMenuIndex == index
              ? Primary.primary
              : hoveredCategoryIndex == index
                  ? Primary.primary.withAlpha((0.2 * 255).toInt())
                  : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              color: selectedMenuIndex == index
                  ? Colors.white
                  : hoveredCategoryIndex == index
                      ? Colors.white
                      : Others.priceColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: selectedMenuIndex == index
                    ? Colors.white
                    : hoveredCategoryIndex == index
                        ? Colors.white
                        : Others.priceColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // int seconds = 0, minutes = 0, hours = 0;
  // String digitSeconds = '00', digitMinutes = '00', digitHours = '00';
  // Timer? timer;
  // bool started = false;
  // List laps = [];
  //
  // void stop() {
  //   timer!.cancel();
  //   setState(() {
  //     started = false;
  //   });
  // }
  //
  // void reset() {
  //   timer!.cancel();
  //   setState(() {
  //     seconds = 0;
  //     minutes = 0;
  //     hours = 0;
  //     digitSeconds = '00';
  //     digitMinutes = '00';
  //     digitHours = '00';
  //     started = false;
  //   });
  // }
  //
  // void addLaps() {
  //   String lap = '$digitHours:$digitMinutes:$digitSeconds';
  //   setState(() {
  //     laps.add(lap);
  //   });
  // }
  //
  // void start() {
  //   started = true;
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     int localSecond = seconds + 1;
  //     int localMinutes = minutes;
  //     int localHours = hours;
  //
  //     if (localSecond > 59) {
  //       if (localMinutes > 59) {
  //         localHours++;
  //         localMinutes = 0;
  //       } else {
  //         localMinutes++;
  //         localSecond = 0;
  //       }
  //     }
  //     setState(() {
  //       seconds = localSecond;
  //       minutes = localMinutes;
  //       hours = localHours;
  //       digitSeconds = (seconds >= 10) ? '$seconds' : '0$seconds';
  //       digitHours = (hours >= 10) ? '$hours' : '0$hours';
  //       digitMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
  //     });
  //   });
  // }

  // Widget _shiftShow() {
  //   return Row(
  //     children: [
  //         Text(
  //          name,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       gapW32,
  //       Text('start shift at $shiftStart'),
  //       gapW32,
  //       Text('$digitHours:$digitMinutes:$digitSeconds')
  //     ],
  //   );
  // }
}

// ignore: must_be_immutable
class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.product, required this.index});
  Map product;
  final int index;
  @override
  State<ItemCard> createState() => ItemCardState();
}

class ItemCardState extends State<ItemCard> {
  bool isClicked = false;
  int counter = 1;
  ProductController productController = Get.find();
  HomeController homeController = Get.find();
  double price = 0.0, showInCardCurrencyPrice = 0.0, showInPosCurrencyPrice = 0.0;
  double tax = 0.0;
  double productLatestRate = 1;
  String qty = '';
  getQty() async {
    String warehouseId = await getWarehouseIdFromPref();
    for (int j = 0; j < widget.product['warehouses'].length; j++) {
      if ('${widget.product['warehouses'][j]['id']}' == warehouseId) {
        setState(() {
          qty = '${widget.product['warehouses'][j]['qty_on_hand']}';
        });
      }
    }
  }

  // final ExchangeRatesController exchangeRatesController = Get.find();
  setPrice() {

    var showPriceLatestRate =widget.product['priceCurrency']['latest_rate'].isEmpty?'1':widget.product['priceCurrency']['latest_rate'];

    var showPosLatestRate =widget.product['posCurrency']['latest_rate'].isEmpty?'1':widget.product['posCurrency']['latest_rate'];

    var finallyRate = calculateRateCur1ToCur2(
        double.parse('${showPriceLatestRate??'1'}'), double.parse('${showPosLatestRate??'1'}'));

    productLatestRate = double.parse(finallyRate);

    price = double.parse('${widget.product['unitPrice']}');

    showInCardCurrencyPrice = double.parse(
        '${Decimal.parse('$price') * Decimal.parse('$productLatestRate')}');
    var rateToPos = calculateRateCur1ToCur2(
        double.parse(showPriceLatestRate), double.parse(productController.posCurrencyLatestRate));
    showInPosCurrencyPrice=double.parse(
        '${Decimal.parse('$price') * Decimal.parse(rateToPos)}');


    price=roundUp(price,2);
    showInCardCurrencyPrice=roundUp(showInCardCurrencyPrice,2);
    showInPosCurrencyPrice=roundUp(showInPosCurrencyPrice,2);

  }

  getTax()async{
    if(homeController.companySubjectToVat=='1'){
      tax = widget.product['taxation'] / 100.0;
    }else{
      tax=0;
    }
  }
  @override
  void initState() {
    super.initState();
    getQty();
    setPrice();
    getTax();
  }
double selectedQty=1;
double finalPrice=0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      return Stack(
        children: [
          InkWell(
            onTap:homeController.isSessionToday ? () async {
              productController.setSelectedItemId('${widget.product['id']}');
              await productController.getAnItemFromBack();
              setState(() {
                qty = '${controller.item['quantity']}';
                widget.product = controller.item;
              });
              setPrice();
              if(!homeController.isMobile.value)
              {
                String id = '${widget.product['id']}';

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 1),
                    );
                  }
                });
                var isAllowedToSellZero = await getIsAllowedToSellZeroFromPref();

                if (controller.orderItemsList.containsKey(id)) {
                  if (double.parse(
                      '${controller.orderItemsList[id]['sign']}${controller
                          .orderItemsList[id]['quantity']}') >=
                      double.parse(qty) &&
                      !isAllowedToSellZero &&
                      !controller.isReturnClicked) {
                    var cantSellZeroMessage =
                    await getCantSellZeroMessageFromPref();
                    if (cantSellZeroMessage.isNotEmpty) {
                      CommonWidgets.snackBar('error', cantSellZeroMessage);
                    } else {
                      showDialog<String>(
                        // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                  ),
                                  elevation: 0,
                                  content: ZeroQuantityDialog(
                                    id: id,
                                    product: controller.orderItemsList[id],
                                    isAlreadyAdded: true,
                                  )));
                    }
                  } else {
                    if (controller.isReturnClicked) {
                      controller.orderItemsList[id]['sign'] = '-';
                    }
                    controller.orderItemsList[id]['quantity'] =
                    '${double.parse(controller.orderItemsList[id]['quantity']) +
                        1}';
                    controller.orderItemsList[id]['final_price'] = double.parse(
                        controller.orderItemsList[id]['price']) *
                        double.parse(controller.orderItemsList[id]['quantity']);
                    controller.orderItemsList[id]['final_price'] = roundUp(
                        controller.orderItemsList[id]['final_price'], 2);
                    controller.calculateSummary();
                  }
                } else {
                  if (controller.isItemFetched) {
                    Map p = {
                      'id': widget.product['id'],
                      'item_name': widget.product['item_name'],
                      'quantity': '1',
                      'tax': tax,
                      'percent_tax': tax == 0 ? 0 : widget.product['taxation'],
                      'discount': 0,
                      'discount_percent': 0,
                      'discount_type_id': '',
                      'original_price': price,
                      //widget.product['unitPrice'],
                      'price': '$showInPosCurrencyPrice',
                      //for order list
                      // widget.product['unitPrice'],
                      'UnitPrice': price,
                      // widget.product['unitPrice'],
                      'final_price': showInPosCurrencyPrice,
                      // widget.product['unitPrice'],
                      // 'symbol': widget.product['priceCurrency']['symbol'] ?? '',
                      'symbol': widget.product['posCurrency']['symbol'] ?? '',
                      'available_qty': controller.item['quantity'],
                      'sign': controller.isReturnClicked ? '-' : '',
                      // 'index': widget.index
                    };
                    if (double.parse(controller.item['quantity']) <= 0 &&
                        !isAllowedToSellZero &&
                        !controller.isReturnClicked) {
                      var cantSellZeroMessage =
                      await getCantSellZeroMessageFromPref();
                      if (cantSellZeroMessage.isNotEmpty) {
                        CommonWidgets.snackBar('error', cantSellZeroMessage);
                      } else {
                        showDialog<String>(
                          // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(9)),
                                    ),
                                    elevation: 0,
                                    content: ZeroQuantityDialog(
                                      id: id,
                                      product: p,
                                      isAlreadyAdded: false,
                                    )));
                      }
                    }
                    isAllowedToSellZero =
                    await getIsAllowedToSellZeroFromPref();
                    if (double.parse(controller.item['quantity']) > 0 ||
                        isAllowedToSellZero ||
                        controller.isReturnClicked) {
                      controller.addToOrderItemsList(id, p);
                      controller.calculateSummary();
                    }
                  }
                }
              }else{
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      contentPadding: const EdgeInsets.all(0),
                      titlePadding: const EdgeInsets.all(0),
                      actionsPadding: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      elevation: 0,
                      content: MobileQuantitiesDialog(
                        product: widget.product,
                        transactionQuantitiesList0:
                        '${controller.item['totalQuantities'] ?? ''} ${controller.item['packageUnitName'] ?? ''}',
                        warehousesList: widget.product['warehouses'] ?? [],
                      ),
                    );
                  },
                );
              }
            }:null,
            child: homeController.isMobile.value
                ?Container(
              margin: EdgeInsets.only(
                  right: Sizes.deviceWidth * 0.007,
                  bottom: Sizes.deviceWidth * 0.007),
              // padding: EdgeInsets.symmetric(
              //     horizontal: Sizes.deviceWidth * 0.005,
              //     vertical: Sizes.deviceHeight * 0.007),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  border: Border.all(
                      color: controller.orderItemsList
                          .containsKey('${widget.product['id']}')
                          ? Primary.primary
                          : Colors.grey.withAlpha((0.2 * 255).toInt()))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft:Radius.circular(12),topRight:Radius.circular(12) ),
                        child: CachedNetworkImage(
                          imageUrl: (widget.product['images'] != null &&
                                  widget.product['images'].isNotEmpty)
                              ? widget.product['images']
                                  [0] // Safely access first image
                              : 'https://theravenstyle.com/rooster-backend/public/storage/WhatsApp%20Image%202024-03-03%20at%2011.41.15%20AM.jpeg',
                          height: Sizes.deviceHeight * 0.18,
                          width: Sizes.deviceWidth ,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => loading(),
                          // errorWidget: (context, url, error) => loading(),
                          errorWidget: (context, url, error) {
                            //print("Error loading image: $error"); // Debug error message
                            return const Icon(Icons.broken_image,
                                size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: Sizes.deviceHeight * 0.06,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Wrap(
                                    children: [
                                      gapW6,
                                      Text(
                                        '${widget.product['item_name'] ?? ''}'.length < 30
                                            ? '${widget.product['item_name'] ?? ''}'
                                            : '${widget.product['item_name'] ?? ''}'
                                                .substring(0, 30),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.isShowQuantitiesOnPosChecked
                                    ? Text(' $qty')
                                    : const SizedBox(),
                                Text(
                                  widget.product['posCurrency'] != null
                                      ? ' ${widget.product['posCurrency']['symbol'] == '\$' ? numberWithComma(showInCardCurrencyPrice.toString()) : numberWithComma((showInCardCurrencyPrice.toString()))}'
                                          '${' ${widget.product['posCurrency']['symbol'] ?? ''}'}   '
                                      : '',
                                ),
                              ],
                            ),
                            qty==''|| double.parse(qty)==0.0?SizedBox(height: Sizes.deviceHeight*0.05,): Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(icon: const Icon(Icons.remove), onPressed: () async {
                                 if( controller.orderItemsList.containsKey(widget.product['id'])){
                                  if (double.parse('${controller
                                      .orderItemsList['${widget.product['id']}']['quantity']}') >
                                      1) {
                                    controller
                                        .orderItemsList['${widget.product['id']}']['quantity'] =
                                    '${double.parse('${controller
                                        .orderItemsList['${widget.product['id']}']['quantity']}') - 1}';
                                    controller
                                        .orderItemsList['${widget.product['id']}']['final_price'] =
                                        double.parse('${controller
                                            .orderItemsList['${widget.product['id']}']['price']}') *
                                            double.parse('${controller
                                                .orderItemsList['${widget.product['id']}']['quantity']}');

                                    controller.calculateSummary();
                                  }}else{
                                   productController.setSelectedItemId('${widget.product['id']}');
                                   await productController.getAnItemFromBack();
                                   setState(() {
                                     qty = '${controller.item['quantity']}';
                                     widget.product = controller.item;
                                   });
                                   setPrice();
                                   if (selectedQty > 1) {
                                     setState(() {
                                       selectedQty = selectedQty - 1;
                                       finalPrice = price * selectedQty;
                                     });
                                   }
                                 }
                                }),
                                Text('$selectedQty'),
                                IconButton(icon: const Icon(Icons.add), onPressed: () async {
                                 if( controller.orderItemsList.containsKey(widget.product['id'])){
                                  if (double.parse(
                                    '${controller.orderItemsList['${widget.product['id']}']['quantity']}',
                                  ) <
                                      double.parse(
                                        '${controller.orderItemsList['${widget.product['id']}']['available_qty']}',
                                      )) {
                                    controller
                                        .orderItemsList['${widget.product['id']}']['quantity'] =
                                    '${double.parse('${controller.orderItemsList['${widget.product['id']}']['quantity']}') + 1}';
                                    controller
                                        .orderItemsList['${widget.product['id']}']['final_price'] =
                                        double.parse(
                                          '${controller.orderItemsList['${widget.product['id']}']['price']}',
                                        ) *
                                            double.parse(
                                              '${controller.orderItemsList['${widget.product['id']}']['quantity']}',
                                            );

                                    controller.calculateSummary();
                                  }}else{
                                   productController.setSelectedItemId('${widget.product['id']}');
                                   await productController.getAnItemFromBack();
                                   setState(() {
                                     qty = '${controller.item['quantity']}';
                                     widget.product = controller.item;
                                   });
                                   setPrice();
                                        if(selectedQty<double.parse('${controller.item['quantity']}')){
                                          setState(() {
                                            selectedQty=selectedQty+1;
                                            finalPrice=price*selectedQty;
                                          });
                                        }
                                    }
                                }),
                              ],
                            ),
                            qty==''|| double.parse(qty)<=0.0?
                             SizedBox(
                                 width:  Sizes.deviceWidth, height: 40,
                                 child: Center(child: Text("out_of_stock".tr, style: TextStyle(color: Colors.red))))
                                :ReusableButtonWithColor(btnText: 'add'.tr, onTapFunction: ()async{
                                  if(homeController.isSessionToday)  {
                                    productController.setSelectedItemId('${widget.product['id']}');
                                    await productController.getAnItemFromBack();
                                    setState(() {
                                    qty = '${controller.item['quantity']}';
                                    widget.product = controller.item;
                                    });
                                    setPrice();
                                    String id = '${widget.product['id']}';

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (_scrollController.hasClients) {
                                        _scrollController.animateTo(
                                          _scrollController.position.maxScrollExtent,
                                          curve: Curves.easeOut,
                                          duration: const Duration(milliseconds: 1),
                                        );
                                      }
                                    });
                                    var isAllowedToSellZero = await getIsAllowedToSellZeroFromPref();

                                    if (controller.orderItemsList.containsKey(id)) {
                                      if (double.parse(
                                          '${controller.orderItemsList[id]['sign']}${controller.orderItemsList[id]['quantity']}') >=
                                          double.parse(qty) &&
                                          !isAllowedToSellZero &&
                                          !controller.isReturnClicked) {
                                        var cantSellZeroMessage =
                                        await getCantSellZeroMessageFromPref();
                                        if (cantSellZeroMessage.isNotEmpty) {
                                          CommonWidgets.snackBar('error', cantSellZeroMessage);
                                        } else {
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
                                                  content: ZeroQuantityDialog(
                                                    id: id,
                                                    product: controller.orderItemsList[id],
                                                    isAlreadyAdded: true,
                                                  )));
                                        }
                                      } else {
                                        if (controller.isReturnClicked) {
                                          controller.orderItemsList[id]['sign'] = '-';
                                        }
                                        controller.orderItemsList[id]['quantity'] =
                                        '${double.parse(controller.orderItemsList[id]['quantity']) + 1}';
                                        controller.orderItemsList[id]['final_price'] = double.parse(
                                            controller.orderItemsList[id]['price']) *
                                            double.parse(controller.orderItemsList[id]['quantity']);
                                        controller.orderItemsList[id]['final_price']=roundUp(controller.orderItemsList[id]['final_price'],2);
                                        controller.calculateSummary();
                                      }
                                    } else {
                                      if (controller.isItemFetched) {
                                        String brand='';
                                        if (widget.product['itemGroups'] != null) {
                                          var firstBrandObject = widget.product['itemGroups']
                                              .firstWhere(
                                                (obj) =>
                                            obj["root_name"]?.toLowerCase() ==
                                                "brand".toLowerCase(),
                                            orElse: () => null,
                                          );
                                          brand =
                                          firstBrandObject == null
                                              ? ''
                                              : firstBrandObject['name'] ?? '';
                                        }
                                        Map p = {
                                          'id': widget.product['id'],
                                          'item_name': widget.product['item_name'],
                                          'quantity': '$selectedQty',
                                          'tax': tax,
                                          'percent_tax':tax==0?0:widget.product['taxation'],
                                          'discount': 0,
                                          'discount_percent': 0,
                                          'discount_type_id': '',
                                          'original_price': price,
                                          //widget.product['unitPrice'],
                                          'price': '$showInPosCurrencyPrice',//for order list
                                          // widget.product['unitPrice'],
                                          'UnitPrice': price,
                                          // widget.product['unitPrice'],
                                          'final_price':selectedQty==1?showInPosCurrencyPrice: finalPrice,
                                          // widget.product['unitPrice'],
                                          // 'symbol': widget.product['priceCurrency']['symbol'] ?? '',
                                          'symbol': widget.product['posCurrency']['symbol'] ?? '',
                                          'available_qty': controller.item['quantity'],
                                          'sign': controller.isReturnClicked ? '-' : '',
                                          'image': widget.product['images']!=null &&  '${widget.product['images']}'!='[]' ?widget.product['images'][0]:'',
                                          'description': widget.product['mainDescription'],
                                          'brand':brand,
                                        };
                                        if (double.parse(controller.item['quantity']) <= 0 &&
                                            !isAllowedToSellZero &&
                                            !controller.isReturnClicked) {
                                          var cantSellZeroMessage =
                                          await getCantSellZeroMessageFromPref();
                                          if (cantSellZeroMessage.isNotEmpty) {
                                            CommonWidgets.snackBar('error', cantSellZeroMessage);
                                          } else {
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
                                                    content: ZeroQuantityDialog(
                                                      id: id,
                                                      product: p,
                                                      isAlreadyAdded: false,
                                                    )));
                                          }
                                        }
                                        isAllowedToSellZero = await getIsAllowedToSellZeroFromPref();
                                        if (double.parse(controller.item['quantity']) > 0 ||
                                            isAllowedToSellZero ||
                                            controller.isReturnClicked) {
                                          controller.addToOrderItemsList(id, p);
                                          controller.calculateSummary();
                                        }
                                      }
                                    }
                                  }
                            },
                              width:  Sizes.deviceWidth, height: 40,radius:12 ,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):Container(
              foregroundDecoration: const RotatedCornerDecoration.withColor(
                badgeCornerRadius: Radius.circular(18),
                color: CupertinoColors.systemGrey3,
                badgeSize: Size(40, 40),
                textSpan: TextSpan(
                  text: 'i',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              margin: EdgeInsets.only(
                  right: Sizes.deviceWidth * 0.007,
                  bottom: Sizes.deviceWidth * 0.007),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.deviceWidth * 0.005,
                  vertical: Sizes.deviceHeight * 0.007),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  border: Border.all(
                      color: controller.orderItemsList
                          .containsKey('${widget.product['id']}')
                          ? Primary.primary
                          : Colors.grey.withAlpha((0.2 * 255).toInt()))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: (widget.product['images'] != null &&
                          widget.product['images'].isNotEmpty)
                          ? widget.product['images']
                      [0] // Safely access first image
                          : 'https://theravenstyle.com/rooster-backend/public/storage/WhatsApp%20Image%202024-03-03%20at%2011.41.15%20AM.jpeg',
                      height: Sizes.deviceHeight * 0.16,
                      width: Sizes.deviceWidth * 0.31,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => loading(),
                      // errorWidget: (context, url, error) => loading(),
                      errorWidget: (context, url, error) {
                        //print("Error loading image: $error"); // Debug error message
                        return const Icon(Icons.broken_image,
                            size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                  SizedBox(
                    height: Sizes.deviceHeight * 0.06,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            gapW6,
                            Text(
                              '${widget.product['item_name'] ?? ''}'.length < 30
                                  ? '${widget.product['item_name'] ?? ''}'
                                  : '${widget.product['item_name'] ?? ''}'
                                  .substring(0, 30),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                // fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['posCurrency'] != null
                            ? ' ${widget.product['posCurrency']['symbol'] == '\$' ? numberWithComma(showInCardCurrencyPrice.toString()) : numberWithComma((showInCardCurrencyPrice.toString()))}'
                            '${' ${widget.product['posCurrency']['symbol'] ?? ''}'}   '
                            : '',
                      ),
                      controller.isShowQuantitiesOnPosChecked
                          ? Text(' $qty Units')
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          homeController.isMobile.value
              ?SizedBox()
              :Positioned(
            top: 1.0,
            right: 10.0,
            child: InkWell(
              child: const SizedBox(
                height: 30,
                width: 30,
              ),
              // const Icon(Icons.info,
              // color: CupertinoColors.systemGrey3,
              // ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      contentPadding: const EdgeInsets.all(0),
                      titlePadding: const EdgeInsets.all(0),
                      actionsPadding: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      elevation: 0,
                      content: QuantitiesDialog(
                        product: widget.product,
                        transactionQuantitiesList0:
                            '${controller.item['totalQuantities'] ?? ''} ${controller.item['packageUnitName'] ?? ''}',
                        warehousesList: widget.product['warehouses'] ?? [],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
