
import 'package:get/get.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import '../const/functions.dart';

class PaymentController extends GetxController{
   bool isReprinted=false;
   setIsReprintedInvoice(bool val){
     isReprinted=val;
     update();
   }
  int selectedCashMethodOption = 2;
  setSelectedCashMethodOption (int val){
    selectedCashMethodOption = val;
    update();
  }

  String invoiceNumber='0';
  // Map selectedMethodsList={};
  List selectedCashingMethodsList=[];
  String clickedPaymentMethodeId='1';
  int clickedPaymentMethodeIndex=1;
  bool isClickedPaymentMethodeVisa=false;
  bool isClickedPaymentMethodeMaster=false;
  double primaryCurrencyRemaining=0.0;
  double primaryCurrencyChange=0.0;
  double remainingWithExchange=0.0;
  double changeWithExchange=0.0;
  String paymentCurrency='';
  String enteredValue='0';
  List paymentMethodList = [
    // {'id': '1', 'title': 'Cash', 'active': '1'},
    // {'id': '2', 'title': 'Bank', 'active': '1'},
    // {'id': '3', 'title': 'Visa', 'active': '1'},
  ];
  bool isOnAccountSelected=false;
  int onAccountIndex=-1;
  // String selectedOrderId='';
  // setSelectedOrderId(String newValue){
  //   selectedOrderId=newValue;
  //   update();
  // }

  setOnAccountIndex(int value){
    onAccountIndex=value;
    update();
  }




  resetAll(){
    isReprinted=false;
    isOnAccountSelected=false;
      invoiceNumber='0';
      selectedCashingMethodsList=[];
      clickedPaymentMethodeId='1';
      clickedPaymentMethodeIndex=1;
      primaryCurrencyRemaining=0.0;
      primaryCurrencyChange=0.0;
      remainingWithExchange=0.0;
      changeWithExchange=0.0;
      paymentCurrency=productController.primaryCurrency;
      enteredValue='${productController.totalPriceWithExchange}';
      // enteredValue=paymentCurrency=='USD'?'${productController.totalPriceWithExchange}':'${productController.totalPrice}';
      update();
  }

  setInvoiceNumber(String value){
    invoiceNumber=value;
    update();
  }

  setIsOnAccountSelected(bool value){
    isOnAccountSelected=value;
    update();
  }

  setEnteredValue(String value){
    enteredValue=value;
    update();
  }

  setRemainingValue(double value){
    primaryCurrencyRemaining=value;
    remainingWithExchange= primaryCurrencyRemaining*double.parse('${productController.latestRate}');
    update();
  }

  addToPaymentMethodList(List orderItem){
    paymentMethodList = [];
    paymentMethodList.addAll(orderItem);
    // paymentMethodList=paymentMethodList.where((element) => '${element['active']}'=='1').toList();
    update();
  }

  addToSelectedMethodsList(Map orderItem){
    selectedCashingMethodsList.add(orderItem);
    update();
  }
  removeFromSelectedMethodsList(Map orderItem){
    selectedCashingMethodsList.remove(orderItem);
    update();
  }
  //
  // addToSelectedMethodsList(String id,Map orderItem){
  //   selectedMethodsList[id]=orderItem;
  //   update();
  // }
  // removeFromSelectedMethodsList(String id){
  //   selectedMethodsList.remove(id);
  //   update();
  // }

  setPriceInCashMethod(int index,String newPrice){
    selectedCashingMethodsList[index]['price']= newPrice;
    update;
  }
  setAuthCodeInCashMethod(int index,String authCode){
    selectedCashingMethodsList[index]['authCode']= authCode;
    update;
  }

  setCurrencyInCashMethod(int index ,String newValue){
    selectedCashingMethodsList[index]['currency']= newValue;
    update;
  }
  //
  // setPriceInCashMethod(String id,String newPrice){
  //   selectedMethodsList[id]['price']= newPrice;
  //   update;
  // }
  //
  // setCurrencyInCashMethod(String id,String newValue){
  //   selectedMethodsList[id]['currency']= newValue;
  //   update;
  // }

  setPaymentCurrency(String newVal){
    paymentCurrency=newVal;
    update();
  }

  setClickedPaymentMethodeId(String newVal){
    clickedPaymentMethodeId=newVal;
    update();
  }

  setClickedPaymentMethodeIndex(int index){
    clickedPaymentMethodeIndex=index;
    update();
  }
  setIsClickedPaymentMethodeVisa(bool val){
    isClickedPaymentMethodeVisa=val;
    isClickedPaymentMethodeMaster=!val;
    update();
  }
  setIsClickedPaymentMethodeMaster(bool val){
    isClickedPaymentMethodeVisa=!val;
    isClickedPaymentMethodeMaster=val;
    update();
  }

  setIsClickedPaymentMethodeVisaOrMaster(bool val){
    isClickedPaymentMethodeVisa=val;
    isClickedPaymentMethodeMaster=val;
    update();
  }

  setPriceAndCurrencyOnAccount(String price,String currency){
    selectedCashingMethodsList[onAccountIndex]['price']=enteredValue;
    selectedCashingMethodsList[onAccountIndex]['currency']=currency;
    update();
  }


  ProductController productController = Get.find();



  calculateRemAndChange(){
    primaryCurrencyChange=0.0;
    changeWithExchange=0.0;
    primaryCurrencyRemaining=0.0;
    remainingWithExchange=0.0;
    double usdSum=0.0;
    double otherCurrencySum=0.0;
    double otherCurrencySumAfterExchange=0.0;
    update;
    for(int i=0;i<selectedCashingMethodsList.length;i++) {
      if(selectedCashingMethodsList[i]['currency']==productController.primaryCurrency){
        usdSum += double.parse(selectedCashingMethodsList[i]['price']);
      }else{
        otherCurrencySum += double.parse(selectedCashingMethodsList[i]['price']);
        otherCurrencySumAfterExchange=otherCurrencySum/double.parse('${productController.latestRate}');
      }
    }
      usdSum+=otherCurrencySumAfterExchange;
      if(usdSum>=productController.totalPriceWithExchange){
        primaryCurrencyChange=usdSum-productController.totalPriceWithExchange;
        changeWithExchange=primaryCurrencyChange*double.parse('${productController.latestRate}');
        primaryCurrencyRemaining=0.0;
        remainingWithExchange=0.0;
      }else{
        primaryCurrencyRemaining=productController.totalPriceWithExchange-usdSum;
        remainingWithExchange= primaryCurrencyRemaining*double.parse('${productController.latestRate}');
        primaryCurrencyChange=0.0;
        changeWithExchange=0.0;
      }
    primaryCurrencyChange=roundUp(primaryCurrencyChange,2);
    changeWithExchange=roundUp(changeWithExchange,2);
    primaryCurrencyRemaining=roundUp(primaryCurrencyRemaining,2);
    remainingWithExchange=roundUp(remainingWithExchange,2);
      update();
    }

  // calculateRemAndChange(){
  //   usdChange=0.0;
  //   changeWithExchange=0.0;
  //   usdRemaining=0.0;
  //   remainingWithExchange=0.0;
  //   double usdSum=0.0;
  //   double otherCurrencySum=0.0;
  //   double otherCurrencySumAfterExchange=0.0;
  //   update;
  //   var keys = selectedMethodsList.keys.toList();
  //   for(int i=0;i<keys.length;i++) {
  //     if(selectedMethodsList[keys[i]]['currency']=='USD'){
  //       usdSum += double.parse(selectedMethodsList[keys[i]]['price']);
  //     }else{
  //       otherCurrencySum += double.parse(selectedMethodsList[keys[i]]['price']);
  //       otherCurrencySumAfterExchange=otherCurrencySum/double.parse('${productController.latestRate}');
  //     }
  //   }
  //     usdSum+=otherCurrencySumAfterExchange;
  //     if(usdSum>=productController.totalPriceWithExchange){
  //       usdChange=usdSum-productController.totalPriceWithExchange;
  //       changeWithExchange=usdChange*double.parse('${productController.latestRate}');
  //       usdRemaining=0.0;
  //       remainingWithExchange=0.0;
  //     }else{
  //       usdRemaining=productController.totalPriceWithExchange-usdSum;
  //       remainingWithExchange= usdRemaining*double.parse('${productController.latestRate}');
  //       usdChange=0.0;
  //       changeWithExchange=0.0;
  //     }
  //     update();
  //   }

}