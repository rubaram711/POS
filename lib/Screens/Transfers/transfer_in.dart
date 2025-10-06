import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/Transfers/print_transfer_in.dart';
import '../../../Widgets/page_title.dart';
import '../../../Widgets/reusable_btn.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Backend/Transfers/transfer_in.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/transfer_controller.dart';
import '../../Widgets/TransferWidgets/reusable_show_info_card.dart';
import '../../Widgets/TransferWidgets/reusable_time_line_tile.dart';
import '../../Widgets/TransferWidgets/under_item_btn.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/table_title.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TransferIn extends StatefulWidget {
  const TransferIn({super.key});

  @override
  State<TransferIn> createState() => _TransferInState();
}

class _TransferInState extends State<TransferIn> {
  // TextEditingController refController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  int currentStep = 0;
  int selectedTabIndex = 0;
  List tabsList = [
    'order_lines',
    'other_information',
  ];
  String? selectedItem = '';

  double listViewLength = Sizes.deviceHeight * 0.09;
  double increment = Sizes.deviceHeight * 0.09;
  final TransferController transferController = Get.find();
  final HomeController homeController = Get.find();
  int progressVar = 0;
  Map data = {};
  bool isInfoFetched = false;
  List<String> warehousesNameList = [];

  String selectedSourceWarehouseIds = '';
  String selectedDestinationWarehouseIds = '';
  clearFieldsForCreateTransfer() async {
    setState(() {
      currentStep = 0;
      selectedTabIndex = 0;
      selectedItem = '';
      progressVar = 0;
      selectedSourceWarehouseIds = '';
      selectedDestinationWarehouseIds = '';
      data = {};
      warehousesNameList = [];
      isInfoFetched = true;
    });
  }

  @override
  void initState() {
    transferController.setIsSubmitAndPreviewClicked(false);
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    clearFieldsForCreateTransfer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isInfoFetched
        ? GetBuilder<TransferController>(
          builder: (transferCont) {
            return Container(
                  padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        homeController.selectedTab.value = 'transfers';
                      },
                      child:   Icon(Icons.arrow_back,
                          size: 22,
                          // color: Colors.grey,
                          color: Primary.primary),
                    ),
                    gapW10,
                    PageTitle(text: 'transfer_in'.tr),
                    // gapW10,
                    // isInfoFetched
                    //     ? InkWell(
                    //   child: Icon(
                    //     Icons.print,
                    //     color: Primary.primary,
                    //   ),
                    //   onTap: () {
                    //     showDialog<String>(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             AlertDialog(
                    //               backgroundColor: Colors.white,
                    //               contentPadding: const EdgeInsets.all(0),
                    //               titlePadding: const EdgeInsets.all(0),
                    //               actionsPadding: const EdgeInsets.all(0),
                    //               shape: const RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.all(
                    //                     Radius.circular(0)),
                    //               ),
                    //               elevation: 0,
                    //               content: PrintTransferIn(
                    //                 transferNumber:  transferCont.selectedTransferIn['transferNumber']??'',
                    //                 date: dateController.text ??'',
                    //                 ref: transferCont.selectedTransferIn['reference']??'',
                    //                 transferTo: transferCont.selectedTransferIn['destWarhouse']??'',),
                    //             ));
                    //     // generateAndPrintPdf();
                    //     // printPdf();
                    //     // _generatePdf();
                    //     // screenshotController
                    //     //     .capture(delay: const Duration(milliseconds: 10))
                    //     //     .then((capturedImage) async {
                    //     //   _exportScreenshotToPdf(context, capturedImage!);
                    //     // }).catchError((onError) {
                    //     //   print('onError');
                    //     //   print(onError);
                    //     // });
                    //   },
                    // ):const SizedBox(),
                  ],
                ),
                gapH16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UnderTitleBtn(
                          text: 'preview'.tr,
                          onTap: () {
                            // setState(() {
                            //   progressVar+=1;
                            // });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return   PrintTransferIn(
                                    transferNumber:  transferCont.selectedTransferIn['transferNumber']??'',
                                    receivedDate:transferCont.selectedTransferIn['receivingDate']!=null? dateController.text:'',
                                    creationDate: transferCont.selectedTransferIn['creationDate'].substring(0,11),
                                    ref: transferCont.selectedTransferIn['reference']??'',
                                    transferTo: transferCont.selectedTransferIn['destWarhouse']??'',
                                    receivedUser: transferCont.selectedTransferIn['receivingUser']??'',
                                    senderUser: transferCont.selectedTransferIn['sendingUser']??'',
                                    status: transferCont.selectedTransferIn['status']??'',
                                    transferFrom: transferCont.selectedTransferIn['sourceWarhouse']??'',
                                    rowsInListViewInTransfer: transferCont.rowsInListViewInTransferIn,
                                  );
                                }));
                          },
                        ),
                        UnderTitleBtn(
                          text: 'submit_and_preview'.tr,
                          onTap: () async{
                            // setState(() {
                            //    progressVar = 0;
                            // });
                            bool isThereItemsEmpty=false;
                            for (var map in transferCont.rowsInListViewInTransferIn) {
                              if ( double.parse('${map!["receivedQty"]}') == 0.0 ||  map!["receivedQty"] == '' ||  map!["receivedQty"]==null) {
                                setState(() {
                                  isThereItemsEmpty=true;
                                });
                                break;
                              }
                            }
                            if(isThereItemsEmpty){
                              CommonWidgets.snackBar(
                                  'error',
                                  'check all order lines and enter the required fields');
                            }else{
                              var res = await addTransferIn(
                                  '${transferController
                                      .selectedTransferIn['id']}',
                                  dateController.text,
                                  transferController
                                      .rowsInListViewInTransferIn);
                              if (res['success'] == true) {
                                CommonWidgets.snackBar(
                                    'Success', res['message']);
                                // transferController.getAllTransactionsFromBack();
                                  transferCont.setIsSubmitAndPreviewClicked(true);
                                // ignore: use_build_context_synchronously
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return   PrintTransferIn(
                                        transferNumber:  transferCont.selectedTransferIn['transferNumber']??'',
                                        receivedDate:transferCont.selectedTransferIn['receivingDate']!=null? dateController.text:'',
                                        creationDate: transferCont.selectedTransferIn['creationDate'].substring(0,11),
                                        ref: transferCont.selectedTransferIn['reference']??'',
                                        transferTo: transferCont.selectedTransferIn['destWarhouse']??'',
                                        receivedUser: transferCont.selectedTransferIn['receivingUser']??'',
                                        senderUser: transferCont.selectedTransferIn['sendingUser']??'',
                                        status: transferCont.selectedTransferIn['status']??'',
                                        transferFrom: transferCont.selectedTransferIn['sourceWarhouse']??'',
                                        rowsInListViewInTransfer: transferCont.rowsInListViewInTransferIn,
                                      );
                                    }));
                              } else {
                                CommonWidgets.snackBar(
                                    'error', res['message'] ??
                                    'error'.tr);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ReusableTimeLineTile(
                            id: 0,
                            progressVar: progressVar,
                            isFirst: true,
                            isLast: false,
                            isPast: true,
                            text: 'processing'.tr),
                        ReusableTimeLineTile(
                            id: 1,
                            progressVar: progressVar,
                            isFirst: false,
                            isLast: false,
                            isPast: false,
                            text: 'pending'.tr),
                        ReusableTimeLineTile(
                          id: 2,
                          progressVar: progressVar,
                          isFirst: false,
                          isLast: true,
                          isPast: false,
                          text: 'received'.tr,
                        ),
                      ],
                    )
                  ],
                ),
                gapH16,
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Others.divider),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(9))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                isInfoFetched
                                    ? Text(
                                    transferCont.selectedTransferIn['transferNumber'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color:
                                        TypographyColor.titleTable))
                                    : const CircularProgressIndicator(),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.05,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('ref'.tr),
                                      ReusableShowInfoCard(
                                        text: transferCont.selectedTransferIn['reference']??'',
                                        width: MediaQuery.of(context).size.width * 0.15,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // gapH16,
                            // Row(
                            //   mainAxisAlignment:
                            //   MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('transfer_from'.tr),
                            //     ReusableShowInfoCard(
                            //       text: transferCont.selectedTransferIn['sourceWarhouse']??'',
                            //       width: MediaQuery.of(context).size.width * 0.25,)
                            //   ],
                            // ),
                            gapH16,
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text('transfer_to'.tr),
                                ReusableShowInfoCard(
                                  text:  transferCont.selectedTransferIn['destWarhouse']??'',
                                  width: MediaQuery.of(context).size.width * 0.25,)
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('date'.tr),
                                  DialogDateTextField(
                                    textEditingController: dateController,
                                    text: '',
                                    textFieldWidth:
                                    MediaQuery.of(context).size.width *
                                        0.15,
                                    validationFunc: (val) {},
                                    onChangedFunc: (val) {},
                                    onDateSelected: (value) {
                                      String rd=transferCont.selectedTransferIn['creationDate'].substring(0,10);
                                      DateTime dt1 = DateTime.parse("$rd 00:00:00");
                                      DateTime dt2 = DateTime.parse("$value 00:00:00");
                                      if(dt2.isBefore(dt1)){
                                        CommonWidgets.snackBar(
                                            'error',
                                            'Received date can\'t be before transfer date');
                                      }else{
                                      dateController.text = value;}
                                    },
                                  ),
                                ],
                              ),
                            ),
                            gapH16,
                            Text('${'total_qty'.tr}: ')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                gapH16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                        spacing: 0.0,
                        direction: Axis.horizontal,
                        children: tabsList
                            .map((element) => _buildTabChipItem(
                            element,
                            tabsList.indexOf(element)))
                            .toList()),
                  ],
                ),
                // tabsContent[selectedTabIndex],
                selectedTabIndex == 0
                    ? Column(
                  children: [
                    Container(
                      padding:const EdgeInsets.symmetric(
                          // horizontal:
                          // MediaQuery.of(context).size.width *
                          //     0.01,
                          vertical: 15),
                      decoration: BoxDecoration(
                          color: Primary.primary,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(6))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TableTitle(
                            text: 'item'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.12,
                          ),
                          TableTitle(
                            text: 'description'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.25,
                          ),
                          TableTitle(
                            text: 'qty_transferred'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.1,
                          ),
                          TableTitle(
                            text: 'pack'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.05,
                          ),
                          TableTitle(
                            text: 'qty_received'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.1,
                          ),
                          TableTitle(
                            text: 'pack'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.05,
                          ),
                          TableTitle(
                            text: 'difference'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.1,
                          ),
                          TableTitle(
                            text: 'pack'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.05,
                          ),
                          TableTitle(
                            text: 'note'.tr,
                            width: MediaQuery.of(context).size.width *
                                0.1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal:
                        //     MediaQuery.of(context).size.width *
                        //         0.01),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                          color: Colors.white,
                        ),
                        child: Column(
                          // crossAxisAlignment:
                          // CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Sizes.deviceHeight * 0.13*transferCont.rowsInListViewInTransferIn.length,
                              child: ListView.builder(
                                padding:  const EdgeInsets.symmetric(
                                    vertical: 10),
                                itemCount: transferCont.rowsInListViewInTransferIn
                                    .length, //products is data from back res
                                itemBuilder: (context, index) =>ReusableItemRowInTransferIn(
                                  transferredItemInfo: transferCont.rowsInListViewInTransferIn[index],
                                index: index,
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    gapH28,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ReusableButtonWithColor(
                          width: MediaQuery.of(context).size.width *
                              0.15,
                          height: 45,
                          onTapFunction: () async {
                            bool isThereItemsEmpty=false;
                            for (var map in transferCont.rowsInListViewInTransferIn) {
                              if ( double.parse('${map!["receivedQty"]}') == 0.0 ||  map!["receivedQty"] == '' ||  map!["receivedQty"]==null) {
                                setState(() {
                                  isThereItemsEmpty=true;
                                });
                                break;
                              }
                            }
                            if(isThereItemsEmpty){
                              CommonWidgets.snackBar(
                                  'error',
                                  'check all order lines and enter the required fields');
                            }else{
                              var res = await addTransferIn(
                                  '${transferController
                                  .selectedTransferIn['id']}',
                                  dateController.text,
                                  transferController
                                      .rowsInListViewInTransferIn);
                              if (res['success'] == true) {
                                CommonWidgets.snackBar(
                                    'Success', res['message']);
                                transferController.getAllTransactionsFromBack();
                                homeController.selectedTab.value =
                                'transfers';
                              } else {
                                CommonWidgets.snackBar(
                                    'error', res['message'] ??
                                    'error'.tr);
                              }
                            }
                          },
                          btnText: 'submit'.tr,
                        ),
                      ],
                    )
                  ],
                )
                    : const SizedBox(),
                gapH40,
              ],
            ),
                  ),
                );
          }
        )
        : const CircularProgressIndicator();
  }

  Widget _buildTabChipItem(String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: ClipPath(
        clipper: const ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9)))),
        child: Container(
          width:name.length*10,// MediaQuery.of(context).size.width * 0.09,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
              color: selectedTabIndex == index ? Primary.p20 : Colors.white,
              border: selectedTabIndex == index
                  ? Border(
                top: BorderSide(color: Primary.primary, width: 3),
              )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 9,
                  blurRadius: 9,
                  // offset: Offset(0, 3),
                )
              ]),
          child: Center(
            child: Text(
              name.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Primary.primary),
            ),
          ),
        ),
      ),
    );
  }

}


class ReusableItemRowInTransferIn extends StatefulWidget {
  const ReusableItemRowInTransferIn({super.key, required this.transferredItemInfo, required this.index});
  final Map transferredItemInfo;
  final int index;
  @override
  State<ReusableItemRowInTransferIn> createState() => _ReusableItemRowInTransferInState();
}

class _ReusableItemRowInTransferInState extends State<ReusableItemRowInTransferIn> {
  TextEditingController receivedQtyController=TextEditingController();
  String deference='';
  TextEditingController noteController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TransferController transferController = Get.find();
  @override
  void initState() {
    receivedQtyController.clear();
    deference='${widget.transferredItemInfo['transferredQty']??''}';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<TransferController>(builder: (cont) {
        return Container(
          // width: MediaQuery.of(context).size.width * 0.63,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(
                //   width:  MediaQuery.of(context).size.width * 0.12,
                //   child: Row(
                //     children: [
                //       Container(
                //         width:  MediaQuery.of(context).size.width * 0.02,
                //         height: 20,
                //         margin:
                //         const EdgeInsets.symmetric(
                //             vertical: 15),
                //         decoration: const BoxDecoration(
                //           image: DecorationImage(
                //             image: AssetImage(
                //                 'assets/images/newRow.png'),
                //             fit: BoxFit.contain,
                //           ),
                //         ),
                //       ),
                //       ReusableShowInfoCard(text: widget.transferredItemInfo['itemName']??'', width: MediaQuery.of(context).size.width * 0.1),
                //     ],
                //   ),
                // ),
                ReusableShowInfoCard(text: widget.transferredItemInfo['itemName']??'', width: MediaQuery.of(context).size.width * 0.12),
                ReusableShowInfoCard(text: widget.transferredItemInfo['mainDescription']??'', width: MediaQuery.of(context).size.width * 0.25),
                ReusableShowInfoCard(text: '${widget.transferredItemInfo['transferredQty']??''}', width: MediaQuery.of(context).size.width * 0.1),
                ReusableShowInfoCard(text: '${widget.transferredItemInfo['transferredQtyPackageName']??''}', width: MediaQuery.of(context).size.width * 0.05),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: ReusableNumberField(
                      textEditingController: receivedQtyController,
                      isPasswordField: false,
                      isCentered: true,
                      hint: '0',
                      onChangedFunc: (val) {
                        _formKey.currentState!.validate();
                        cont.setEnteredQtyInTransferIn(widget.index, val);
                        setState(() {
                          deference='${double.parse('${widget.transferredItemInfo['transferredQty']}') - double.parse(val??'0')}';
                        });
                        cont.setDifferenceInTransferIn(widget.index, deference);
                      },
                      validationFunc: (String? value) {
                        if( value!.isEmpty || double.parse(value)<=0 ){
                          return 'must be >0';
                        }
                        return null;
                      },
                    )),
                ReusableShowInfoCard(text: '${widget.transferredItemInfo['transferredQtyPackageName']??''}', width: MediaQuery.of(context).size.width * 0.05),
                ReusableShowInfoCard(text: deference, width: MediaQuery.of(context).size.width * 0.1),
                ReusableShowInfoCard(text: '${widget.transferredItemInfo['transferredQtyPackageName']??''}', width: MediaQuery.of(context).size.width * 0.05),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: ReusableTextField(
                      onChangedFunc: (val){
                        cont.setNoteInTransferIn(widget.index, val);
                      },
                      validationFunc: (val){},
                      hint: '',
                      isPasswordField: false,
                      textEditingController:noteController
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}



