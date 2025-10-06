import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/const/Sizes.dart';
import '../../Backend/CategoriesBackend/get_categories.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/colors.dart';
import 'dart:async';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../Home/home_content.dart';
import 'mobile_barcode_scanner.dart';
TextEditingController mobileSearchByBarcodeController = TextEditingController();
// ScrollController _scrollController = ScrollController();


class MobileStock extends StatefulWidget {
  const MobileStock({super.key});

  @override
  State<MobileStock> createState() => _MobileStockState();
}

class _MobileStockState extends State<MobileStock> {
  final ScrollController scrollControllerForGridView = ScrollController();

  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();
  HomeController homeController = Get.find();
  OrdersController ordersController = Get.find();
  List categoriesList = [
    {'category_name': 'All Menu'},
  ];
  bool isCategoriesFetched = false;
  getCategoriesFromBack() async {
    var p = await getCategories();
    var data =
    p.where((element) => element['category_name'] != 'STANDARD').toList();
    categoriesList.addAll(data);
    setState(() {
      isCategoriesFetched = true;
    });
  }
  getInfoFromPref() async {
    var showQuantitiesOnPos = await getShowQuantitiesOnPosFromPref();
    productController.isShowQuantitiesOnPosChecked =
    showQuantitiesOnPos == '1' ? true : false;
  }
  // getCurrenciesFromBackend() async {
  //   var p = await getCurrencies();
  //   if ('$p' != '[]') {
  //     productController.setDiscountTypesList(p['discountTypes']);
  //     paymentController.addToPaymentMethodList(p['cachingMethods']);
  //     productController.setIsDataFetched(true);
  //   }
  // }

  Timer? searchOnStoppedTyping;
  //
  // _onChangeHandler(value) {
  //   const duration = Duration(milliseconds: 800);
  //   if (searchOnStoppedTyping != null) {
  //     setState(() => searchOnStoppedTyping!.cancel()); // clear timer
  //   }
  //   setState(
  //           () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  // }
  //
  // search(value) async {
  //   await productController.getAllProductsFromBackWithSearch();
  // }


  @override
  void initState() {
    super.initState();
    // productController.productsList = [];
    // productController.currentPage=1;
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
    // productController.selectedCustomerId = '-1';
    // productController.selectedCustomerIdWithOk = '-1';
    // productController.selectedCustomerObject = };
    // // getInfoFromPref();
    // getCurrenciesFromBackend();
    // getCategoriesFromBack();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth ) / 2; //
    double itemHeight = screenHeight * 0.95;
    return GetBuilder<ProductController>(
      builder: (proCont) {
        return  Column(
            children: [
              // Search field
              gapH16,
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                child: DialogTextFieldWithoutText(
                  // hint: 'search_by'.tr,
                  hint: 'scan_barcode'.tr,
                  textEditingController: mobileSearchByBarcodeController,
                  textFieldWidth: MediaQuery.of(context).size.width ,
                  validationFunc: (value) {},
                  onIconClickedFunc: () {
                    // Get.to(()=>const CameraScannerPage());
                    // homeController.selectedTab.value =
                    //     'camera_scanner_page';
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const MobileBarcodeScannerPage();
                        }));
                  },
                  isHasCloseIcon: true,
                  onCloseIconClickedFunc: () async {
                    mobileSearchByBarcodeController.clear();
                    searchByBarcodeOrNameController.clear();
                    await productController
                        .getAllProductsFromBackWithSearch();
                  },
                  onChangedFunc: (val) async {
                    searchByBarcodeOrNameController.text=val;
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
                          // if (proCont.productsList.length == 1) {
                          //   WidgetsBinding.instance
                          //       .addPostFrameCallback((_) {
                          //     if (_scrollController.hasClients) {
                          //       _scrollController.animateTo(
                          //         _scrollController
                          //             .position.maxScrollExtent,
                          //         curve: Curves.easeOut,
                          //         duration: const Duration(
                          //             milliseconds: 1),
                          //       );
                          //     }
                          //   });
                          //   String id =
                          //       '${proCont.productsList[0]['id']}';
                          //   if(proCont.orderItemsList.keys.toList().contains(id)){
                          //     proCont.orderItemsList[id]['quantity']='${
                          //     double.parse(proCont.orderItemsList[id]['quantity'])+1
                          //     }';
                          //   }else{
                          //     double tax = proCont.productsList[0]
                          //     ['taxation'] /
                          //         100.0;
                          //
                          //     // double usdPrice = 0.0,
                          //     //     otherCurrencyPrice = 0.0;
                          //     // var priceCurrency = proCont.productsList[0]['priceCurrency']['name'];
                          //     var resultForPrice = proCont
                          //         .productsList[0]['priceCurrency']['latest_rate']
                          //         .isEmpty
                          //         ? '1'
                          //         : proCont
                          //         .productsList[0]['priceCurrency']['latest_rate'];
                          //     var showPriceLatestRate =
                          //     resultForPrice != null ? '$resultForPrice' : '1';
                          //     var price = double.parse(
                          //         '${proCont.productsList[0]['unitPrice']}');
                          //     // var showInCardCurrencyPrice = double.parse(
                          //     //     '${Decimal.parse('$price') * Decimal.parse('$productLatestRate')}');
                          //
                          //     var rateToPos = calculateRateCur1ToCur2(
                          //         double.parse(showPriceLatestRate),
                          //         double.parse(
                          //             productController.posCurrencyLatestRate));
                          //     var showInPosCurrencyPrice = double.parse(
                          //         '${Decimal.parse('$price') *
                          //             Decimal.parse(rateToPos)}');
                          //
                          //     price = roundUp(price, 2);
                          //     showInPosCurrencyPrice =
                          //         roundUp(showInPosCurrencyPrice, 2);
                          //
                          //     Map p = {
                          //       'id': '${proCont.productsList[0]['id']}',
                          //       'item_name': proCont
                          //           .productsList[0]['item_name'],
                          //       'quantity': '1',
                          //       'available_qty': proCont
                          //           .productsList[0]['quantity'],
                          //       'tax': tax,
                          //       'percent_tax': proCont.productsList[0]
                          //       ['taxation'],
                          //       'discount': 0,
                          //       'discount_percent': 0,
                          //       'discount_type_id': '',
                          //       'original_price':
                          //       price,
                          //       //widget.product['unitPrice'],
                          //       'price':
                          //       '$showInPosCurrencyPrice',
                          //       // widget.product['unitPrice'],
                          //       'UnitPrice': price,
                          //       // widget.product['unitPrice'],
                          //       'final_price':
                          //       showInPosCurrencyPrice,
                          //       // widget.product['unitPrice'],
                          //       'symbol': proCont.productsList[0]
                          //       ['posCurrency']['symbol'] ??
                          //           '',
                          //       'sign':
                          //       proCont.isReturnClicked ? '-' : ''
                          //     };
                          //
                          //     if (homeController.isSessionToday) {
                          //       proCont.addToOrderItemsList(id, p);
                          //
                          //       proCont.calculateSummary();
                          //     }
                          //   }
                          // }
                        }));
                  },
                  radius: 9,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextField(
              //     controller: mobileSearchByBarcodeController,
              //     decoration: InputDecoration(
              //       hintText: "Search for an item",
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     onChanged: (val){
              //       _onChangeHandler(val);
              //       },
              //   ),
              // ),

              // Categories (horizontal list)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder:
                      (context, index) => _categoryCard(
                    title: categoriesList[index]['category_name'],
                    index: index,
                    id: '${categoriesList[index]['id'] ?? '0'}',
                  ),
                ),
              ),

              // Product grid
              Expanded(
                child: GridView.builder(
                  controller: scrollControllerForGridView,
                  padding: const EdgeInsets.all(8),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: itemWidth/itemHeight,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: proCont.productsList.length,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      product: proCont.productsList[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          );
      },
    );
  }

  int selectedMenuIndex = 0;
  int hoveredCategoryIndex = -1;
  Widget _categoryCard({
    required String title,
    required int index,
    required String id,
  }) {
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
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: const Color(0xff1f2029),
          border:
          selectedMenuIndex == index
              ? Border.all(color: Primary.primary, width: 1)
              : hoveredCategoryIndex == index
              ? Border.all(color: Colors.white, width: 1)
              : Border.all(
            color: Colors.grey.withAlpha((0.2 * 255).toInt()),
            width: 1,
          ),
          color:
          selectedMenuIndex == index
              ? Primary.primary
              : hoveredCategoryIndex == index
              ? Primary.primary.withAlpha((0.2 * 255).toInt())
              : Colors.white,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color:
              selectedMenuIndex == index
                  ? Colors.white
                  : hoveredCategoryIndex == index
                  ? Colors.white
                  : Colors.black87,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


