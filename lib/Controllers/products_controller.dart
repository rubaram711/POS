import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/ProductsBackend/get_an_item.dart';
import 'package:pos_project/Controllers/client_controller.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import '../../Backend/ProductsBackend/get_products.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Screens/Home/home_content.dart';
import '../const/functions.dart';

class ProductController extends GetxController {
  int selectedMobileTab=1;
  setSelectedMobileTab(int val){
    selectedMobileTab=val;
    update();
  }


  bool isDataFetched = false;
  setIsDataFetched(bool val) {
    isDataFetched = val;
    update();
  }


  bool isWasteClicked = false;
  setIsWasteClicked(bool val) {
    isWasteClicked = val;
    update();
  }

  bool isCashAvailable = false;
  setIsCashAvailable(bool val) {
    isCashAvailable = val;
    update();
  }

  bool isShowQuantitiesOnPosChecked = true;
  setIsShowQuantitiesOnPosChecked(bool val) {
    isShowQuantitiesOnPosChecked = val;
    update();
  }

  Map<String, bool> isFirstClick = {};
  setIsFirstClickVal(String key, bool val) {
    isFirstClick[key] = val;
    update();
  }
  // String cantSellZeroMessage='';

  bool isRetrieveOrderSelected = false;
  bool isClickedPark = false;
  bool isReturnClicked = false;
  setIsClickedPark(bool value) {
    isClickedPark = value;
    update();
  }

  setIsReturnClicked(bool value) {
    isReturnClicked = value;
    update();
  }

  List productsList = [];
  // bool isProductsFetched = false;
  var hasMore = true;
  var isLoading = false;
  int currentPage = 1;
  getAllProductsFromBack() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    String warehouseId = await getWarehouseIdFromPref();
    var p = await getAllProducts(
      searchByBarcodeOrNameController.text,
      selectedCategoryId,
      '1',
      warehouseId,
      searchByBarcodeController.text,
      currentPage,
    );
    if ('$p' != '[]') {
      productsList.addAll(p);
      currentPage++;
    } else {
      hasMore = false;
    }
    isLoading = false;

    update();
  }

  getAllProductsFromBackWithSearch() async {
    isLoading = true;
    productsList = [];
    String warehouseId = await getWarehouseIdFromPref();
    var p = await getAllProducts(
      searchByBarcodeOrNameController.text,
      selectedCategoryId,
      '1',
      warehouseId,
      searchByBarcodeController.text,
      -1,
    );
    productsList = p;
    isLoading = false;
    update();
  }

  Map item = {};
  bool isItemFetched = false;
  String selectedItemId = '';

  setSelectedItemId(String val) {
    selectedItemId = val;
    update();
  }

  getAnItemFromBack() async {
    item = {};
    isItemFetched = false;
    String warehouseId = await getWarehouseIdFromPref();
    var p = await getAnItem(selectedItemId, warehouseId);
    if (p['success'] == true) {
      item = p['data'];
      // print('object ${p['data']['quantity']}');
      isItemFetched = true;
    }
    update();
  }

  String primaryCurrency = '';
  String posCurrency = '';
  String posCurrencyLatestRate = '';
  String primaryCurrencyLatestRate = '1';
  double totalDiscountAsPercent = 0;
  double totalDiscount = 0;
  double totalDiscountOnTotalPriceBeforeTax = 0;
  double totalDiscountWithExchange = 0;
  String selectedOrderItemId = '';
  int selectedOrderItemIndex = -1;
  double totalPrice = 0.0;
  double totalPriceWithExchange = 0.0;
  double latestRate = 0.0;
  bool isProductsInfoFetched = false;
  Map data = {};
  List<String> categoriesNames = [];
  List categoriesIds = [];
  String selectedCategoryId = '';
  List discountTypesList = [
    {
      'id': 0,
      'type': 'custom discount',
      'discount_value': '0',
      'float_discount_value': 0,
    },
  ];
  Map orderItemsList = {
    // 1:{
    //   'id':1,
    //   'item_name':'ll',
    //   'quantity':1,
    //   'tax':22,
    //   'discount':0,
    //   'discount_type':'',
    //   'original_price':1,
    //   'price':1.22,
    //   'final_price':1.22,
    //   'symbol':'usd',
    // }
  };
  double taxesSum = 0;
  double taxesSumWithExchange = 0;
  double totalPriceBeforeTax = 0.0;

  setQuantityOfItemINOrderList(String id, String value) {
    orderItemsList[id]['quantity'] = value;
    update();
  }

  setPriceOfItemINOrderList(String id, String value) {
    orderItemsList[id]['price'] = value;
    update();
  }

  // ClientController clientController=Get.find();
  resetAll() {
    isRetrieveOrderSelected = false;
    totalDiscountAsPercent = 0;
    totalDiscount = 0;
    totalDiscountOnTotalPriceBeforeTax = 0;
    totalDiscountWithExchange = 0;
    selectedOrderItemId = '';
    selectedOrderItemIndex = -1;
    totalPrice = 0.0;
    totalPriceWithExchange = 0.0;
    selectedCategoryId = '';
    orderItemsList = {
      // 1:{
      //   'id':1,
      //   'item_name':'ll',
      //   'quantity':1,
      //   'tax':22,
      //   'discount':0,
      //   'discount_type':'',
      //   'original_price':1,
      //   'price':1.22,
      //   'final_price':1.22,
      //   'symbol':'usd',
      // }
    };
    taxesSum = 0;
    taxesSumWithExchange = 0;
    totalPriceBeforeTax = 0.0;
    update();
  }

  // setProductsCurrencies(String val){
  //   productsCurrencies=val;
  //     update();
  // }

  // setExchangeCurrency(String val){
  //   primaryCurrency=val;
  //     update();
  // }

  // setOrderListCurrency(String val){
  //   posCurrency=val;
  //     update();
  // }

  setTotalDiscountAsPercent(double val) {
    totalDiscountAsPercent = val;
    update();
  }

  setTotalDiscount(double val) {
    totalDiscount = val;
    totalDiscountWithExchange = double.parse(
      '${double.parse('$totalDiscount') / double.parse('$latestRate')}',
    );
    update();
  }

  setTotalDiscountOnTotalPriceBeforeTax(double val) {
    totalDiscountOnTotalPriceBeforeTax = val;
    totalDiscountWithExchange = double.parse(
      '${double.parse('$totalDiscount') / double.parse('$latestRate')}',
    );
    update();
  }

  // setLatestRate(double val){
  //     latestRate=val;
  //     update();
  // }

  setSelectedOrderItemIndex(int val) {
    selectedOrderItemIndex = val;
    update;
  }

  setSelectedOrderItemId(String val) {
    selectedOrderItemId = val;
    update;
  }

  setSelectedCategoryId(String newVal) {
    selectedCategoryId = newVal;
    update();
  }

  bool isLineDiscountSelected = false;
  setIsLineDiscountSelected(bool val) {
    isLineDiscountSelected = val;
    update();
  }

  setDiscountTypesList(List newList) {
    discountTypesList = [
      {
        'id': 0,
        'type': 'custom discount',
        'discount_value': '0',
        'float_discount_value': 0,
      },
    ];
    discountTypesList.addAll(newList);
    // update();
  }


  String selectedDiscountTypeId = '0';
  setSelectedDiscountTypeId(String newVal) {
    selectedDiscountTypeId = newVal;
    update();
  }

  String selectedLineDiscountTypeId = '0';
  setSelectedLineDiscountTypeId(String newVal) {
    selectedLineDiscountTypeId = newVal;
    update();
  }

  List<double> finalPricesList = [];
  addToFinalPriceList(double val) {
    finalPricesList.add(val);
  }

  removeFromFinalPriceList(double val) {
    finalPricesList.remove(val);
  }

  recalculateTotal() {
    totalPrice = finalPricesList.reduce((a, b) => a + b);
  }

  addToOrderItemsList(String id, Map orderItem) {
    orderItemsList[id] = orderItem;
    update();
  }

  removeFromOrderItemsList(String id) {
    orderItemsList.remove(id);
    update();
  }

  double subtotal = 0.0;
  double subtotalWithExchange = 0.0;
  calculateSummary() {
    totalPrice = 0.0;
    totalPriceBeforeTax = 0.0;
    taxesSum = 0.0;
    taxesSumWithExchange = 0.0;
    subtotal = 0.0;
    subtotalWithExchange = 0.0;
    update;
    var keys = orderItemsList.keys.toList();
    // print('latest $latestRate');
    for (int i = 0; i < keys.length; i++) {
      double divisor = orderItemsList[keys[i]]['tax'] + 1;
      double quantity = double.parse(orderItemsList[keys[i]]['quantity']);
      double price = double.parse(orderItemsList[keys[i]]['price']);
      subtotal += double.parse(
        '${orderItemsList[keys[i]]['sign']}${orderItemsList[keys[i]]['final_price']}',
      );
      if (orderItemsList[keys[i]]['sign'] == '') {
        totalPrice = double.parse(
          '${Decimal.parse('$totalPrice') + Decimal.parse('${orderItemsList[keys[i]]['final_price']}')}',
        );
        if (orderItemsList[keys[i]]['percent_tax'] == 0) {
          totalPriceBeforeTax += orderItemsList[keys[i]]['final_price'];
        } else {
          double productPriceBeforeTax = quantity * price / divisor;
          totalPriceBeforeTax += productPriceBeforeTax;
        }
      } else {
        totalPrice = double.parse(
          '${Decimal.parse('$totalPrice') - Decimal.parse('${orderItemsList[keys[i]]['final_price']}')}',
        );
        if (orderItemsList[keys[i]]['percent_tax'] == 0) {
          totalPriceBeforeTax -= orderItemsList[keys[i]]['final_price'];
        } else {
          double productPriceBeforeTax = quantity * price / divisor;
          totalPriceBeforeTax -= productPriceBeforeTax;
        }
      }
    }

    if (totalDiscountAsPercent != 0) {
      setTotalDiscount(
        double.parse(
          '${Decimal.parse('$totalPrice') * Decimal.parse('${totalDiscountAsPercent / 100.0}')}',
        ),
      );
      setTotalDiscountOnTotalPriceBeforeTax(
        double.parse(
          '${Decimal.parse('$totalPriceBeforeTax') * Decimal.parse('${totalPriceBeforeTax / 100.0}')}',
        ),
      );

      totalPrice = totalPrice - (totalPrice * totalDiscountAsPercent / 100.0);
      totalPriceBeforeTax =
          totalPriceBeforeTax -
          (totalPriceBeforeTax * totalDiscountAsPercent / 100.0);
    }
    taxesSum = double.parse(
      '${Decimal.parse('${totalPrice - totalPriceBeforeTax}')}',
    );
    taxesSumWithExchange = double.parse(
      '${double.parse('$taxesSum') / double.parse('$latestRate')}',
    );
    if (posCurrency != primaryCurrency) {
      totalPriceWithExchange = double.parse(
        '${double.parse('$totalPrice') / double.parse('$latestRate')}',
      );
    } else {
      totalPriceWithExchange = totalPrice;
    }
    totalPrice=roundUp(totalPrice,2);
    totalPriceWithExchange=roundUp(totalPriceWithExchange,2);
    taxesSum=roundUp(taxesSum,2);
    taxesSumWithExchange=roundUp(taxesSumWithExchange,2);
    totalDiscount=roundUp(totalDiscount,2);
    totalDiscountWithExchange=roundUp(totalDiscountWithExchange,2);
    subtotal=roundUp(subtotal,2);
    subtotalWithExchange=roundUp(subtotalWithExchange,2);
    update();
  }

  setIsRetrieveOrderSelected(bool val) {
    isRetrieveOrderSelected = val;
  }

  HomeController homeController = Get.find();


  setSelectedOrderInfo(Map order, bool isReturn) {
    subtotal = 0.0;
    subtotalWithExchange = 0.0;
    for (var item in order['orderItems']) {
      double price = 0.0,
          discount=0.0,
          posCurrencyDiscount=0.0,
          // showInCardCurrencyPrice = 0.0,
          showInPosCurrencyPrice = 0.0;
      double tax = 0.0;
      // double productLatestRate = 1;
      // double usdPrice = 0.0, otherCurrencyPrice = 0.0;
    
      if (homeController.companySubjectToVat == '1') {
        tax = item['taxation'] / 100.0;
      } else {
        tax = 0;
      }

      // var showPriceLatestRate =item['price_currency']['latest_rate'];
      // var showPosLatestRate =item['pos_currency']['latest_rate'];
      // var finallyRate = calculateRateCur1ToCur2(
      //   double.parse(showPriceLatestRate),
      //   double.parse(showPosLatestRate),
      // );
      // productLatestRate = double.parse(finallyRate);
      price = double.parse('${item['price_after_tax']}');
      // showInCardCurrencyPrice = double.parse(
      //   '${Decimal.parse('$price') * Decimal.parse('$productLatestRate')}',
      // );
      // var rateToPos = calculateRateCur1ToCur2(
      //   double.parse(showPriceLatestRate),
      //   double.parse(posCurrencyLatestRate),
      // );
      showInPosCurrencyPrice = double.parse('${item['price_after_tax']}');
      // if (item['price_currency']['symbol'] == '\$') {
      //     usdPrice = double.parse('${item['price']}');
      //     otherCurrencyPrice = double.parse(
      //         '${Decimal.parse('$usdPrice') * Decimal.parse('$latestRate')}');
      //   } else {
      //     otherCurrencyPrice = double.parse('${item['price']}');
      //     usdPrice = double.parse(
      //         '${double.parse('$otherCurrencyPrice') / double.parse('$latestRate')}');
      // }
      if(item['discount_type'] != null){
        discount= double.parse(item['discount_type']['discount_value']) * price / 100;
        // price=price-discount;
        posCurrencyDiscount= double.parse(item['discount_type']['discount_value']) * showInPosCurrencyPrice / 100;
        // showInPosCurrencyPrice=showInPosCurrencyPrice-posCurrencyDiscount;
      }
      
      Map itemMap = {
        'id': item['item_id'],
        'item_name': item['item_name'],
        'quantity': item['quantity'],
        // 'available_qty': 100,
        'tax': tax / 100,
        'percent_tax': tax,
        'discount':
            item['discount_type'] == null
                ? 0
                : double.parse(item['discount_type']['discount_value']) *
                    price /
                    100,
        'discount_percent':
            item['discount_type'] == null
                ? 0
                : double.parse(item['discount_type']['discount_value']),
        'discount_type_id':
            item['discount_type'] == null
                ? ''
                : '${item['discount_type']['id']}',
        'original_price': price,
        'price': '$showInPosCurrencyPrice',
        'UsdPrice': price,
        'final_price':
            double.parse('$showInPosCurrencyPrice') *
            double.parse('${item['quantity']}'), //todo check
        'symbol': item['pos_currency']['symbol'] ?? '',
        'sign': '${item['quantity']}'.startsWith('-') || !isReturn ? '' : '-',
     'image':'',
     'brand':'',
     'description':'',
      };
      orderItemsList['${item['item_id']}'] = itemMap;
    }
    // if(order['client']['client_number']!='CashCustomer'){
    //   clientController.selectedCustomerId ='${order['client']['id']}';
    //   clientController.selectedCustomerIdWithOk ='${order['client']['id']}';
    //
    //   clientController.selectedCustomerObject=order['client'];
    // }
    if (isReturn) {
      calculateSummary();
    } else {
      taxesSumWithExchange = double.parse('${order['posCurrencyTaxValue']}');
      totalDiscount =order['posCurrencyGrantedDiscount'] == null ||
          double.parse('${order['posCurrencyGrantedDiscount']}') == 0.00
              ? double.parse('${order['posCurrencyDiscountValue']}')
              : double.parse('${order['posCurrencyGrantedDiscount']}');
      taxesSum = double.parse('${order['primaryCurrencyTaxValue']}');
      totalDiscountWithExchange =order['primaryCurrencyGrantedDiscount'] == null ||
          double.parse('${order['primaryCurrencyGrantedDiscount']}') == 0.00
          ? double.parse('${order['primaryCurrencyDiscountValue']??'0'}')
          : double.parse('${order['primaryCurrencyGrantedDiscount']}');
      totalPriceWithExchange = double.parse('${order['primaryCurrencyTotal']}');
      totalPrice = double.parse('${order['posCurrencyTotal']}');
      selectedDiscountTypeId =order['primaryCurrencyGrantedDiscount'] == null ||
          double.parse('${order['primaryCurrencyGrantedDiscount']}') == 0.00
          ? '${order['discount_type']!=null?order['discount_type']['id']:''}':'-1';
      if(order['customDiscountPercentage']!='0' && order['customDiscountPercentage']!=null){
        selectedDiscountTypeId='0';
        totalDiscountAsPercent=double.parse('${order['customDiscountPercentage']}');
        totalDiscount=double.parse('${order['posCurrencyCustomDiscountValue']}');
      }
      calculateSubTotal();

    }
    update();
  }

  calculateSubTotal(){
    var keys = orderItemsList.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      subtotal += double.parse(
        '${orderItemsList[keys[i]]['sign']}${orderItemsList[keys[i]]['final_price']}',
      );
    }
    subtotal=roundUp(subtotal,2);
    subtotalWithExchange=roundUp(subtotalWithExchange,2);
  }
  seSignForOrderItem(String val) {
    orderItemsList[selectedOrderItemId]['sign'] = val;
    update();
  }
}
