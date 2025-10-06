// import 'dart:async';
import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/Backend/get_company_settings.dart';
import 'package:pos_project/Controllers/pos_controller.dart';
import 'package:pos_project/Screens/Home/payment_screen.dart';
import 'package:pos_project/Screens/Home/print_invoice_screen.dart';
import 'package:pos_project/Screens/Home/print_waste.dart';
import 'package:pos_project/Screens/MobileScreens/mobile_home.dart';
import 'package:pos_project/Screens/Transfers/transfers.dart';
import 'package:pos_project/Widgets/loading.dart';
import 'package:pos_project/Widgets/sittings_menu.dart';
import 'package:responsive_builder/responsive_builder.dart';
// import 'package:intl/intl.dart';
import '../../Backend/CashTrayBackend/get_open_cash_tray_id.dart';
import '../../Backend/HeadersBackend/get_headers.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Controllers/cash_trays_controller.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Controllers/role_controller.dart';
import '../../Controllers/session_controller.dart';
import '../../Controllers/transfer_controller.dart';
import '../../Controllers/warehouse_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../Authorization/sign_up_screen.dart';
import '../CashTray/cash_tray_options.dart';
import '../Docs/docs.dart';
import '../Sessions/open_close_session.dart';
import '../Sessions/sessions.dart';
import '../Sessions/sessions_options.dart';
import '../Transfers/transfer_details.dart';
import '../Transfers/transfer_in.dart';
import '../Transfers/transfer_out.dart';
import 'camera_scanner_page.dart';
import 'home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(
          tablet: 750,
          desktop: 950,
          watch: 300,
        ),
        mobile: (p0) {
          homeController.isMobile.value = true;
          return const MobileHomePage();
        },
        tablet: (p0) {
          homeController.isTablet = true;
          return const HomeBody();
        },
        desktop: (p0) {
          homeController.isTablet = false;
          return const HomeBody();
        },
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Map<String, Widget> contentList = {
    'Home': const HomeContent(),
    'payment': const PaymentScreen(),
    'print': const PrintScreen(),
    'print_waste': const PrintWasteScreen(),
    'transfers': const Transfers(),
    'transfer_in': const TransferIn(),
    'transfer_details': const TransferDetails(),
    'transfer_out': const TransferOut(),
    'docs': const Docs(),
    'sessions_options': const SessionsOptions(),
    'open_close_session': const OpenCloseSession(),
    'sessions': const Sessions(),
    'camera_scanner_page': const CameraScannerPage(),
  };
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
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null? '${res['data']['primaryCurrency']['id']??''}': '${res['data']['posCurrency']['id']??''}',
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null?'${res['data']['primaryCurrency']['symbol']??''}': '${res['data']['posCurrency']['symbol']??''}',
      '${res['data']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['primaryCurrency']['latest_rate']??''}',
        homeController.companyName=='PETEXPERT'||res['data']['posCurrency']==null?'${res['data']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['primaryCurrency']['latest_rate']??''}': '${res['data']['posCurrency']['latest_rate']??''}',
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
      // print('primaryCurrency $primaryCurrencyLatestRate');
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

  @override
  void initState() {

    // start();
    // checkInternet();
    // getSessionAndCashTray();
    // getDate();
    // getInfoFromPref();
    // getCurrenciesFromPref();
    super.initState();
    getAndSaveCompanySettings();

    scheduleMidnightTask();

    checkInternet();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    getSessionAndCashTray();
    getDate();
    getInfoFromPref();
    // getCurrenciesFromPref();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          // color: Color(0xff17181f),
        ),
        child: Obx(
          () => Container(
            color: Others.bg,
            // padding: const EdgeInsets.only(right: 20, top: 15, left: 20),
            // width: MediaQuery.of(context).size.width - 80,
            child: Column(
              children: [
                // const HomeAppBar(),
                // const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  height: Sizes.deviceHeight * 0.05,
                  child: Center(
                    child: GetBuilder<HomeController>(
                      builder: (homeController) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                homeController.companyName == 'HorecaExpo'
                                    ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            'assets/images/MontyLogo.png',
                                          ),
                                        ),
                                        Text(
                                          '    ${homeController.companyName}  (${homeController.posName})',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Primary.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                    : Text(
                                      'Rooster    ${homeController.companyName}  (${homeController.posName})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Primary.primary,
                                      ),
                                    ),
                                gapW10,
                                Text(
                                  '${homeController.currentSessionNumber == '' ? '' : '${'session_number'.tr}: ${homeController.currentSessionNumber}'}   '
                                  '${homeController.currentCashTrayNumber == '' ? '' : '${'cash_tray_number'.tr}: ${homeController.currentCashTrayNumber}'}  '
                                  ' ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold, color: Primary.primary),
                                ),
                                // gapW48,
                                // _shiftShow(),
                              ],
                            ),

                            Row(
                              children: [
                                Icon(
                                  homeController.isWifiConnected
                                      ? Icons.wifi
                                      : Icons.wifi_off_sharp,
                                  color:
                                      homeController.isWifiConnected
                                          ? Colors.green
                                          : Colors.grey,
                                  size: 23,
                                ),
                                gapW20,
                                Text(
                                  homeController.useName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Primary.primary,
                                  ),
                                ),
                                gapW20,
                                SettingMenu(
                                  itemsList: [
                                    PopupMenuItem<String>(
                                      value: '1',
                                      onTap: () {
                                        productController.resetAll();
                                        paymentController.resetAll();
                                        clientController.resetAll();

                                        homeController.selectedTab.value =
                                            'Home';
                                      },
                                      child: Text('home'.tr),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '2',
                                      onTap: () {
                                        homeController.selectedTab.value =
                                            'transfers';
                                      },
                                      child: Text('transfers'.tr),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '3',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return const SessionsOptions();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text('sessions'.tr),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '4',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return const CashTrayOptions();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text('cash_tray'.tr),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '5',
                                      onTap: () async {
                                        homeController.selectedTab.value =
                                            'docs';
                                      },
                                      child: Text('docs'.tr),
                                    ),
                                    PopupMenuItem<String>(
                                      value: '6',
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return const SignInScreen();
                                            },
                                          ),
                                        );
                                        await saveUserInfoLocally(
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                        );
                                        await saveCompanySettingsLocally(
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                          '',
                                        );
                                        await saveHeader1Locally('', '','', '', '', '', '','','','','','','','','' );
                                        await saveRoleIdInfoLocally('');
                                        await saveRoleNameInfoLocally('');
                                        await savePosIdInfoLocally('');
                                        await savePosNameInfoLocally('');
                                        await saveWarehouseIdInfoLocally('');
                                        await saveRolesLocally([]);
                                        Get.delete<HomeController>(force: true);
                                        Get.delete<ProductController>(
                                          force: true,
                                        );
                                        Get.delete<PaymentController>(
                                          force: true,
                                        );
                                        Get.delete<TransferController>(
                                          force: true,
                                        );
                                        Get.delete<WarehouseController>(
                                          force: true,
                                        );
                                        Get.delete<SessionController>(
                                          force: true,
                                        );
                                        Get.delete<OrdersController>(
                                          force: true,
                                        );
                                        Get.delete<CashTraysController>(
                                          force: true,
                                        );
                                        Get.delete<RoleController>(force: true);
                                        Get.delete<PossController>(force: true);
                                        Get.put(HomeController());
                                        Get.put(ProductController());
                                        Get.put(PaymentController());
                                        Get.put(TransferController());
                                        Get.put(WarehouseController());
                                        Get.put(SessionController());
                                        Get.put(OrdersController());
                                        Get.put(CashTraysController());
                                        Get.put(RoleController());
                                        Get.put(PossController());
                                        // Get.reload<HomeController>();
                                      },
                                      child: Text('exit'.tr),
                                    ),
                                  ],
                                ),
                                // InkWell(
                                //   onTap: () async {
                                //     Navigator.pushReplacement(context,
                                //         MaterialPageRoute(builder: (BuildContext context) {
                                //           return const SignUpScreen();
                                //         }));
                                //     await saveUserInfoLocally('', '', '', '', '');
                                //   },
                                //   child: const Icon(Icons.logout,
                                //       size: 18,
                                //       // color: Colors.grey,
                                //       color: Colors.red),
                                // ),
                                // gapW20,
                                // InkWell(
                                //   onTap: () async {
                                //     homeController.selectedTab.value = 'transfers';
                                //   },
                                //   child: const Icon(Icons.transfer_within_a_station,
                                //       size: 18,
                                //       // color: Colors.grey,
                                //       color: Colors.grey),
                                // ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                homeController.isCurrenciesFetched.value
                    ? contentList[homeController.selectedTab.value] ?? const SizedBox()
                    :loading(),
              ],
            ),
          ),
        ),
      ),
    );

    //   Row(
    //   children: [
    //
    //     // Container(
    //     //   width: 70,
    //     //   color: Colors.white,
    //     //   padding: const EdgeInsets.only(top: 24, right: 8, left: 8),
    //     //   height: MediaQuery.of(context).size.height,
    //     //   child: _sideMenu(),
    //     // ),
    //     Expanded(
    //       child: Container(
    //         decoration: const BoxDecoration(
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(12),
    //               topRight: Radius.circular(12)),
    //           // color: Color(0xff17181f),
    //         ),
    //         child:  Obx(
    //                 () => Container(
    //                   color: Others.bg,
    //                   width: MediaQuery.of(context).size.width - 80,
    //                   child: Column(
    //               children: [
    //                   // const HomeAppBar(),
    //                   // const Spacer(),
    //                   contentList[homeController.selectedTab.value] ??
    //                       const SizedBox(),
    //               ],
    //             ),
    //                 )),
    //       ),
    //     ),
    //   ],
    // );
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
  //       Text(
  //         homeController.name,
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
