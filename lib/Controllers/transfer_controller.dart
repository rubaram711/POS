
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Backend/ProductsBackend/get_products.dart';
import '../../Backend/Transfers/get_transfers.dart';


class TransferController extends GetxController{
  bool isSubmitAndPreviewClicked=false;
  setIsSubmitAndPreviewClicked(bool val){
    isSubmitAndPreviewClicked=val;
    update();
  }
  List productsList = [];
  List<String> productsNames = [];
  List productsIds = [];
  bool isProductsFetched = false;
  getAllProductsFromBack(String warehouseId) async {
    productsList= [];
    productsNames = [];
    productsIds = [];
    isProductsFetched = false;
    var p = await getAllProducts('','','',warehouseId,'',-1);
    for (var item in p) {
      productsNames.add('${item['item_name']}');
      productsIds.add(item['id']);
      update();
    }
    productsList.addAll(p);
    isProductsFetched= true;
    update();
  }

  // List<Widget> orderLinesList = [];
  double imageSpaceHeight = 90;

  // addToOrderLinesList(Widget p){
  //   orderLinesList.add(p);
  //   update();
  // }
  // removeFromOrderLinesList(int index){
  //   orderLinesList.removeAt(index);
  //   update();
  // }

  increaseImageSpace(double val){
    imageSpaceHeight=imageSpaceHeight+val;
    update();
  }




//transfers section
  TextEditingController searchInTransfersController = TextEditingController();
  List transfersList=[];
  bool isTransactionsFetched = false;
  getAllTransactionsFromBack() async{
    isSubmitAndPreviewClicked=false;
    transfersList=[];
    isTransactionsFetched = false;
    update();
    var p=await getAllTransfers(searchInTransfersController.text);
    transfersList=p;
    transfersList=transfersList.reversed.toList();
    isTransactionsFetched=true;
    update();
  }



  //transfer out document
  Map<String,Widget> orderLinesInTransferOutList = {};
  bool imageAvailableInTransferOut=false;
  double imageSpaceHeightInTransferOut = 90;
  TextEditingController transferFromControllerInTransferOut = TextEditingController();
  TextEditingController transferToControllerInTransferOut = TextEditingController();
  String transferToIdInTransferOut='';
  String transferFromIdInTransferOut='';
  double listViewLengthInTransferOut =  50;
  double increment = 50;

  List rowsInListViewInTransferOut=[];
  clearList(){
    rowsInListViewInTransferOut=[];
    update();
  }
  addToRowsInListViewInTransferOut(Map p){
    rowsInListViewInTransferOut.add(p);
    update();
  }
  removeFromRowsInListViewInTransferOut(int index){
    rowsInListViewInTransferOut.removeAt(index);
    update();
  }

  setListViewLengthInTransferOut(double val){
    listViewLengthInTransferOut=val;
    update();
  }
  setIncrement(double val){
    listViewLengthInTransferOut=val;
    update();
  }
  incrementListViewLengthInTransferOut(double val){
    listViewLengthInTransferOut=listViewLengthInTransferOut+val;
    update();
  }
  decrementListViewLengthInTransferOut(double val){
    listViewLengthInTransferOut=listViewLengthInTransferOut-val;
    update();
  }
  setTransferToIdInTransferOut(String value){
    transferToIdInTransferOut=value;
    update();
  }
  setTransferFromIdInTransferOut(String value){
    transferFromIdInTransferOut=value;
    update();
  }
  initialTransferOut(){
    orderLinesInTransferOutList = {};
    productsList= [];
    productsNames = [];
    productsIds = [];
    isProductsFetched = false;
  }

  resetTransferOut(){
    orderLinesInTransferOutList = {};
    productsList= [];
    productsNames = [];
    productsIds = [];
    isProductsFetched = false;
    update();
  }
  addToOrderLinesInTransferOutList(String index,Widget p){
    orderLinesInTransferOutList[index]=p;
    update();
  }
  removeFromOrderLinesInTransferOutList(String index){
    orderLinesInTransferOutList.remove(index);
    update();
  }

  // Map itemsListInTransferOut={
  //   // 1:{
  //   //   'itemId':1,
  //   //   'replenishedQty':'ll',
  //   //   'replenishedQtyPackageId':1,//todo change
  //   //   'note':22,
  //   // }
  // };
  // addToItemsListInTransferOut(String index,Map orderItem){
  //   itemsListInTransferOut[index]=orderItem;
  //   update();
  // }
  // removeFromItemsListInTransferOut(String index){
  //   itemsListInTransferOut.remove(index);
  //   update();
  // }

  setItemIdInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['itemId']=val;
    update();
  }
  setItemNameInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['itemName']=val;
    update();
  }
  setItemDescriptionInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['mainDescription']=val;
    update();
  }
  setEnteredQtyInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['transferredQty']=val;
    update();
  }
  setProductsPackagesInTransferOut(int index,List<String> val){
    rowsInListViewInTransferOut[index]['productsPackages']=val;
    update();
  }
  setQtyOnHandPackagesTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['qtyOnHandPackages']=val;
    update();
  }
  setPackageNameInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['transferredQtyPackageName']=val;
    update();
  }
  setQtyOnHandPackagesInSourceInTransferOut(int index,String val){
    rowsInListViewInTransferOut[index]['qtyOnHandPackagesInSource']=val;
    update();
  }

  increaseImageSpaceInTransferOut(double val){
    imageSpaceHeightInTransferOut=imageSpaceHeightInTransferOut+val;
    update();
  }
  changeBoolVarInTransferOut(bool val){
    imageAvailableInTransferOut=val;
    update();
  }




  //transfer in document
  Map selectedTransferIn={};
  List rowsInListViewInTransferIn=[];


  setSelectedTransferIn(Map map){
    selectedTransferIn=map;
    update();
  }
  resetTransferIn(){
    rowsInListViewInTransferIn = [];
    selectedTransferIn={};
    isSubmitAndPreviewClicked=false;
    update();
  }
  clearRowsInListViewInTransferIn(){
    rowsInListViewInTransferIn=[];
    update();
  }
  addToRowsInListViewInTransferIn(List p){
    rowsInListViewInTransferIn=p;
    update();
  }

  setEnteredQtyInTransferIn(int index,String val){
    rowsInListViewInTransferIn[index]['receivedQty']=val;
    update();
  }
  setNoteInTransferIn(int index,String val){
    rowsInListViewInTransferIn[index]['note']=val;
    update();
  }
  setDifferenceInTransferIn(int index,String val){
    rowsInListViewInTransferIn[index]['qtyDifference']=val;
    update();
  }


}