import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/Screens/MobileScreens/mobile_home_content.dart';
import 'package:pos_project/Screens/MobileScreens/order_in_cart_tab.dart';
import '../../Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import '../../Backend/HeadersBackend/get_headers.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Backend/get_company_settings.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/loading.dart';
import '../../const/colors.dart';
import 'dart:async';
import '../../Backend/get_currencies.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import 'mobile_barcode_scanner.dart';
import 'mobile_stoke.dart';
import 'settings_page.dart';


class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  List<Widget> contentList = [
    const MobileHomeContent(),
    const MobileStock(),
    const OrderInCartTab(),
    SettingsPage(),
  ];
  final HomeController homeController = Get.find();
  final ProductController productController = Get.find();
  final PaymentController paymentController = Get.find();
  final ClientController clientController = Get.find();

  // final ExchangeRatesController exchangeRatesController = Get.find();

  getInfoFromPref() async {
    String name = await getNameFromPref();
    var company = await getCompanyNameFromPref();
    homeController.companyName = company;
    var posName = await getPosTerminalNameFromPref();
    homeController.posName = posName;
    homeController.useName = name;
    var companySubjectToVat = await getCompanySubjectToVatFromPref();
    homeController.companySubjectToVat = companySubjectToVat;
    var vat = getCompanyVatFromPref();
    homeController.vat = '$vat';
    var address=await getCompanyAddressFromPref();
    homeController.companyAddress = address;
    var showQuantitiesOnPos = await getShowQuantitiesOnPosFromPref();
    productController.isShowQuantitiesOnPosChecked =
    showQuantitiesOnPos == '1' ? true : false;
  }
  getAndSaveCompanySettings()async{
    var headersRes=await getAllHeaders();
    if(headersRes['success']==true && '${headersRes['data']}'!='[]'){
      var header = headersRes['data'][0]??[];
      await saveHeader1Locally(
        header['logo']??'',
        header['fullCompanyName']??'',
        header['email']??'',
        '${header['vat']??'0'}',
        header['mobileNumber']??'',
        header['phoneNumber']??'',
        '${header['trn']??''}',
        header['bankInfo']??'',
        header['address']??'',
        header['phoneCode']??'',
        header['mobileCode']??'',
        header['localPayments']??'',
        '${header['companySubjectToVat']??'1'}',
        header['headerName']??'',
        '${header['id']??''}',
      );
    }
    var res =await getCompanySettings();
    if(res['success']==true){
      // print('object');print('${res['data']}');
      await saveCompanySettingsLocally(
        '${res['data']['costCalculationType']??''}',
        '${res['data']['showQuantitiesOnPos']??''}',
        // res['data']['logo']??'',
        // res['data']['fullCompanyName']??'',
        // res['data']['email']??'',
        // res['data']['vat']??'0',
        // res['data']['mobileNumber'] ??'',
        // res['data']['phoneNumber'] ??'',
        // res['data']['trn'] ??'',
        // res['data']['bankInfo'] ??'',
        // res['data']['address'] ??'',
        // res['data']['phoneCode'] ??'',
        // res['data']['mobileCode'] ??'',
        // res['data']['localPayments'] ??'',
        res['data']['primaryCurrency']['name'] ??'USD',
        '${res['data']['primaryCurrency']['id']??''}',
        '${res['data']['primaryCurrency']['symbol']??''}',
        // '${res['data']['companySubjectToVat']??'1'}',
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null?res['data']['primaryCurrency']['name'] ??'USD':res['data']['posCurrency']['name'],
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null?'${res['data']['primaryCurrency']['id']??''}': '${res['data']['posCurrency']['id']??''}',
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null?'${res['data']['primaryCurrency']['symbol']??''}': '${res['data']['posCurrency']['symbol']??''}',
        '${res['data']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['primaryCurrency']['latest_rate']??''}',
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null? '${res['data']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['primaryCurrency']['latest_rate']??''}': '${res['data']['posCurrency']['latest_rate']??''}',
        '${res['data']['showLogoOnPos']??'0'}',
      );}
    getCurrenciesFromPref();
  }
  getCurrenciesFromPref() async {
    // await exchangeRatesController.getExchangeRatesListAndCurrenciesFromBack(
    //   withUsd: true,
    // );
    var primaryCurrency = await getCompanyPrimaryCurrencyFromPref();
    var posCurrency = await getCompanyPosCurrencyFromPref();
    var primaryCurrencyLatestRate = await getPrimaryCurrencyLatestRateFromPref();
    var posCurrencyLatestRate = await getPosCurrencyLatestRateFromPref();
    // print('primaryCurrencyggg $primaryCurrencyLatestRate');
    // print('primaryCurrency $posCurrencyLatestRate');
    productController.primaryCurrency = primaryCurrency;
    paymentController.paymentCurrency = primaryCurrency;
    productController.posCurrency = posCurrency;
    productController.posCurrencyLatestRate = posCurrencyLatestRate;
    productController.primaryCurrencyLatestRate = primaryCurrencyLatestRate;
    productController.latestRate = double.parse(posCurrencyLatestRate);

    homeController.isCurrenciesFetched.value=true;
  }
  // getCurrenciesFromPref() async {
  //   await exchangeRatesController.getExchangeRatesListAndCurrenciesFromBack(
  //     withUsd: true,
  //   );
  //   var primaryCurrency = await getCompanyPrimaryCurrencyFromPref();
  //   var posCurrency = await getCompanyPosCurrencyFromPref();
  //   productController.primaryCurrency = primaryCurrency;
  //   paymentController.paymentCurrency = primaryCurrency;
  //   productController.posCurrency = posCurrency;
  //   if (primaryCurrency == posCurrency) {
  //     productController.posCurrencyLatestRate = '1';
  //     productController.primaryCurrencyLatestRate = '1';
  //     productController.latestRate = 1;
  //   } else {
  //     var resultForPrimary = exchangeRatesController.exchangeRatesList
  //         .firstWhere(
  //           (item) => item["currency"] == primaryCurrency,
  //           orElse: () => null,
  //         );
  //     var resultForPos = exchangeRatesController.exchangeRatesList.firstWhere(
  //       (item) => item["currency"] == posCurrency,
  //       orElse: () => null,
  //     );
  //     var primaryLatestRate =
  //         resultForPrimary != null
  //             ? '${resultForPrimary["exchange_rate"]}'
  //             : '1';
  //     var posLatestRate =
  //         resultForPos != null ? '${resultForPos["exchange_rate"]}' : '1';
  //     productController.posCurrencyLatestRate = posLatestRate;
  //     productController.primaryCurrencyLatestRate = primaryLatestRate;
  //     var finallyRate = calculateRateCur1ToCur2(
  //       double.parse(primaryLatestRate),
  //       double.parse(posLatestRate),
  //     );
  //     productController.latestRate = double.parse(finallyRate);
  //   }
  // }

  String currentSessionId = '';

  getSessionAndCashTray() async {
    var res1 = await getOpenSessionId();
    if ('${res1['data']}' != '[]') {
      currentSessionId = '${res1['data']['session']['id']}';
      homeController.isSessionToday = res1['data']['isToday'];
      homeController.currentSessionNumber =
      '${res1['data']['session']['sessionNumber']}';
      if (!homeController.isSessionToday) {
        productController.isCashAvailable = false;
        Get.showSnackbar(
          GetSnackBar(
            title: 'Hello!',
            message:
            'This session has been open since yesterday. '
                'You cannot create new orders in this session.'
                ' To start a new session,'
                ' you must first close all cash trays and complete any pending orders.',
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.black54,
          ),
        );
      }
    }
    var userId = await getIdFromPref();
    var p = await getOpenCashTrayId(currentSessionId, userId);
    if ('$p' != '[]') {
      homeController.currentCashTrayNumber = '${p['cashTrayNumber']}';
      if (!homeController.isSessionToday) {
        productController.isCashAvailable = false;
      } else {
        productController.isCashAvailable = true;
      }
    }
  }

  getDate() {
    homeController.date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  checkInternet() async {
    await InternetConnection().hasInternetAccess;
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          {
            homeController.setIsWifiConnected(true);
            // The internet is now connected
            break;
          }
        case InternetStatus.disconnected:
          {
            homeController.setIsWifiConnected(false);
            // The internet is now disconnected
            break;
          }
      }
    });
  }

  Timer? midnightTimer;

  @override
  void dispose() {
    midnightTimer?.cancel();
    super.dispose();
  }

  void scheduleMidnightTask() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = tomorrow.difference(now);

    midnightTimer = Timer(durationUntilMidnight, () {
      getSessionAndCashTray();
      // After calling at midnight, schedule the next one
      scheduleMidnightTask();
    });
  }


  getCurrenciesFromBackend() async {
    var p = await getCurrencies();
    if ('$p' != '[]') {
      productController.setDiscountTypesList(p['discountTypes']);
      paymentController.addToPaymentMethodList(p['cachingMethods']);
      productController.setIsDataFetched(true);
    }
  }
  @override
  void initState() {
    super.initState();
    getAndSaveCompanySettings();
    scheduleMidnightTask();

    // checkInternet();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    getSessionAndCashTray();
    getDate();
    getInfoFromPref();
    // getCurrenciesFromPref();
    // });
    productController.productsList = [];
    productController.currentPage=1;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollControllerForGridView.addListener(() {
    //     if (scrollControllerForGridView.position.pixels >= scrollControllerForGridView.position.maxScrollExtent &&
    //         !productController.isLoading) {
    //       productController.getAllProductsFromBack();
    //     }
    //   });
    // });
    // getInfoFromPref();
    // productController.getAllProductsFromBack();
    clientController.selectedCustomerId = '-1';
    clientController.selectedCustomerIdWithOk = '-1';
    clientController.selectedCustomerObject = {};
    // getInfoFromPref();
    getCurrenciesFromBackend();
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (proCont) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Obx(() =>
                Expanded(
                    // height: MediaQuery.of(context).size.height-kBottomNavigationBarHeight-50,
                    child:homeController.isCurrenciesFetched.value
                        ? contentList[proCont.selectedMobileTab]
                        :loading()),)
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
            currentIndex: proCont.selectedMobileTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Primary.primary,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items:  [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory),
                  label: 'stock'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  //orderItemsList.values.fold(0, (sum, item) => sum + (item['quantity'] ?? 0));
                  label: '${proCont.orderItemsList.isEmpty
                      ? 'cart'.tr
                      :proCont.orderItemsList.values.fold(0, (sum, item) => sum + int.parse(double.parse(item['quantity']).toStringAsFixed(0)))}',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_vert),
                  label: 'more'.tr,
                ),

                //BottomNavigationBarItem(
                //       icon: Stack(
                //         children: [
                //           Icon(Icons.shopping_cart),
                //           Positioned(
                //             right: 0,
                //             top: 0,
                //             child: Container(
                //               padding: EdgeInsets.all(2),
                //               decoration: BoxDecoration(
                //                 color: Colors.teal,
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               constraints: BoxConstraints(
                //                 minWidth: 14,
                //                 minHeight: 14,
                //               ),
                //               child: Text(
                //                 '7', // عداد السلة
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 10,
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       label: '',),
              ],
              onTap: (value){
                proCont.setSelectedMobileTab(value);
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Primary.primary,
              child: const Icon(Icons.qr_code_scanner,color: Colors.white,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MobileBarcodeScannerPage();
                    }));
              },
            ),
          ),
        );
      },
    );
  }
}


