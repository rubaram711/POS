
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/transfer_controller.dart';
import 'package:pos_project/Screens/Transfers/print_transfer_in.dart';
import '../../Controllers/home_controller.dart';
import '../../Widgets/page_title.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_more.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../Widgets/table_item.dart';
import '../../Widgets/table_title.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';

class Transfers extends StatefulWidget {
  const Transfers({super.key});

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> {
  double listViewLength = 100;
  String selectedNumberOfRows = '10';
  int selectedNumberOfRowsAsInt=10;
  int start = 1;
  bool isArrowBackClicked = false;
  bool isArrowForwardClicked = false;
  final HomeController homeController = Get.find();
  final TransferController transferController = Get.find();
  bool isNumberOrderedUp=true;
  bool isCreationOrderedUp=true;
  // bool isCustomerOrderedUp=true;
  // bool isSalespersonOrderedUp=true;

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
    });
    await transferController.getAllTransactionsFromBack();
  }


  @override
  void initState() {
    transferController.searchInTransfersController.text='';
    listViewLength = Sizes.deviceHeight * (0.09 * transferController.transfersList.length);
    transferController.getAllTransactionsFromBack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferController>(
      builder: (cont) {
        return Container(
          padding:  EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.02),
          height: MediaQuery.of(context).size.height * 0.95,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            homeController.selectedTab.value = 'Home';
                          },
                          child:   Icon(Icons.arrow_back,
                              size: 22,
                              // color: Colors.grey,
                              color: Primary.primary),
                        ),
                        gapW10,
                        PageTitle(text: 'transfers'.tr),
                      ],
                    ),
                    ReusableButtonWithColor(
                      width: homeController.isTablet? MediaQuery.of(context).size.width * 0.25:MediaQuery.of(context).size.width * 0.15,
                      height: 45,
                      onTapFunction: () {
                        homeController.selectedTab.value = 'transfer_out';
                      },
                      btnText: 'create_new_transfer'.tr,
                    ),
                  ],
                ),
                gapH24,
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.59,
                  child: ReusableSearchTextField(
                    hint: '${"search".tr}...',
                    textEditingController: cont.searchInTransfersController,
                    onChangedFunc: (value) {
                      cont.searchInTransfersController.text=value;
                      _onChangeHandler(value);
                    },
                    validationFunc: (val) {},
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                ReusableChip(
                  name: 'all_transfers'.tr,
                ),
                Column(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Primary.primary,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(6))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          tableTitleWithOrderArrow('number'.tr,
                              MediaQuery.of(context).size.width * 0.09, () {
                                setState(() {
                                  isNumberOrderedUp=!isNumberOrderedUp;
                                  isNumberOrderedUp
                                      ? cont.transfersList.sort((a, b) => a['transferNumber'].compareTo(b['transferNumber']))
                                      : cont.transfersList.sort((a, b) => b['transferNumber'].compareTo(a['transferNumber']));
                                });
                              }),
                          tableTitleWithOrderArrow('transfer_date'.tr,
                              MediaQuery.of(context).size.width * 0.09, () {
                                setState(() {
                                  isCreationOrderedUp=!isCreationOrderedUp;
                                  isCreationOrderedUp?
                                  cont.transfersList.sort((a, b) => a['creationDate'].compareTo(b['creationDate']))
                                      :cont.transfersList.sort((a, b) => b['creationDate'].compareTo(a['creationDate']));
                                });
                              }),
                          TableTitle(
                            text: 'src_whse'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'dest_whse'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'task'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'sender_user'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'receiver_user'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'received_date'.tr,
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          TableTitle(
                            text: 'status'.tr,
                            width: MediaQuery.of(context).size.width * 0.13,
                          ),
                          TableTitle(
                            text: 'more'.tr,
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                    cont.isTransactionsFetched
                        ?Container(
                      color: Colors.white,
                      height:MediaQuery.of(context).size.height*0.55,// listViewLength,
                      child: ListView.builder(
                        itemCount:cont.transfersList.length,// cont.transfersList.length>9?selectedNumberOfRowsAsInt: cont.transfersList.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            TransfersAsRowInTable(
                              info:  cont.transfersList[index],
                              index: index,
                            ),
                            const Divider()
                          ],
                        ),
                      ),
                    ):const CircularProgressIndicator(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       '${'rows_per_page'.tr}:  ',
                    //       style: const TextStyle(
                    //           fontSize: 13, color: Colors.black54),
                    //     ),
                    //     Container(
                    //       width: 60,
                    //       height: 30,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(6),
                    //           border: Border.all(color: Colors.black, width: 2)),
                    //       child: Center(
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton<String>(
                    //             borderRadius: BorderRadius.circular(0),
                    //             items: ['10', '20', '50', 'all'.tr]
                    //                 .map((String value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(
                    //                   value,
                    //                   style: const TextStyle(
                    //                       fontSize: 12, color: Colors.grey),
                    //                 ),
                    //               );
                    //             }).toList(),
                    //             value: selectedNumberOfRows,
                    //             onChanged: (val) {
                    //               setState(() {
                    //                 selectedNumberOfRows = val!;
                    //                 if(val=='10'){
                    //                   listViewLength =  cont.transfersList.length < 10
                    //                       ?Sizes.deviceHeight * (0.09 *  cont.transfersList.length)
                    //                       : Sizes.deviceHeight * (0.09 * 10);
                    //                   selectedNumberOfRowsAsInt= cont.transfersList.length < 10?  cont.transfersList.length:10;
                    //                 }if(val=='20'){
                    //                   listViewLength =  cont.transfersList.length < 20
                    //                       ? Sizes.deviceHeight * (0.09 *  cont.transfersList.length)
                    //                       : Sizes.deviceHeight * (0.09 * 20);
                    //                   selectedNumberOfRowsAsInt= cont.transfersList.length < 20?  cont.transfersList.length:20;
                    //                 }if(val=='50'){
                    //                   listViewLength =  cont.transfersList.length < 50
                    //                       ? Sizes.deviceHeight * (0.09 *  cont.transfersList.length)
                    //                       : Sizes.deviceHeight * (0.09 * 50);
                    //                   selectedNumberOfRowsAsInt= cont.transfersList.length < 50?  cont.transfersList.length:50;
                    //                 }if(val=='all'.tr){
                    //                   listViewLength = Sizes.deviceHeight * (0.09 *  cont.transfersList.length);
                    //                   selectedNumberOfRowsAsInt=  cont.transfersList.length;
                    //                 }
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     gapW16,
                    //     Text(selectedNumberOfRows=='all'.tr?'${'all'.tr} of ${ cont.transfersList.length}':'$start-$selectedNumberOfRows of ${ cont.transfersList.length}',
                    //         style: const TextStyle(
                    //             fontSize: 13, color: Colors.black54)),
                    //     gapW16,
                    //     InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             isArrowBackClicked = !isArrowBackClicked;
                    //             isArrowForwardClicked = false;
                    //           });
                    //         },
                    //         child: Row(
                    //           children: [
                    //             Icon(
                    //               Icons.skip_previous,
                    //               color: isArrowBackClicked
                    //                   ? Colors.black87
                    //                   : Colors.grey,
                    //             ),
                    //             Icon(
                    //               Icons.navigate_before,
                    //               color: isArrowBackClicked
                    //                   ? Colors.black87
                    //                   : Colors.grey,
                    //             ),
                    //           ],
                    //         )),
                    //     gapW10,
                    //     InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             isArrowForwardClicked = !isArrowForwardClicked;
                    //             isArrowBackClicked = false;
                    //           });
                    //         },
                    //         child: Row(
                    //           children: [
                    //             Icon(
                    //               Icons.navigate_next,
                    //               color: isArrowForwardClicked
                    //                   ? Colors.black87
                    //                   : Colors.grey,
                    //             ),
                    //             Icon(
                    //               Icons.skip_next,
                    //               color: isArrowForwardClicked
                    //                   ? Colors.black87
                    //                   : Colors.grey,
                    //             ),
                    //           ],
                    //         )),
                    //     gapW40,
                    //   ],
                    // )
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  String hoverTitle = '';
  String clickedTitle = '';
  bool isClicked = false;
  tableTitleWithOrderArrow(String text, double width, Function onClickedFunc) {
    return SizedBox(
      width: width,
      child: Center(
        child: InkWell(
          onTap: () {
            setState(() {
              clickedTitle = text;
              hoverTitle = '';
              isClicked = !isClicked;
              onClickedFunc();
            });
          },
          onHover: (val) {
            if (val) {
              setState(() {
                hoverTitle = text;
              });
            } else {
              setState(() {
                hoverTitle = '';
              });
            }
          },
          child: clickedTitle == text
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text.length>8?'${text.substring(0,8)}...':text,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              isClicked
                  ? const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
                  : const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              )
            ],
          )
              : hoverTitle == text
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${text.length>7?text.substring(0,6):text}...',
                  style: TextStyle(
                      color: Colors.white.withAlpha((0.5 * 255).toInt()),
                      fontWeight: FontWeight.bold)),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white.withAlpha((0.5 * 255).toInt()),
              )
            ],
          )
              : Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class ReusableChip extends StatelessWidget {
  const ReusableChip({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    HomeController homeController=Get.find();
    return InkWell(
      onTap: () {},
      child: ClipPath(
        clipper: const ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9)))),
        child: Container(
          width:homeController.isTablet? MediaQuery.of(context).size.width * 0.25: MediaQuery.of(context).size.width * 0.09,
          height: MediaQuery.of(context).size.height * 0.07,
          // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              color: Primary.p20,
              border: Border(
                top: BorderSide(color: Primary.primary, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 9,
                  blurRadius: 9,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Primary.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class TransfersAsRowInTable extends StatelessWidget {
  const TransfersAsRowInTable(
      {super.key, required this.info, required this.index,  this.isDesktop=true});
  final Map info;
  final int index;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {

    final HomeController homeController = Get.find();
    final TransferController transferController = Get.find();
    return InkWell(
      onDoubleTap: (){
        if(info['status'] == 'sent') {
          homeController.selectedTab.value = 'transfer_in';
        }else{
          homeController.selectedTab.value = 'transfer_details';
        }
        transferController.setSelectedTransferIn(info);
        transferController.addToRowsInListViewInTransferIn(info['transferItems']);
      },
      child: Container(
        padding: const EdgeInsets.symmetric( vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TableItem(
              text: '${info['transferNumber'] ?? ''}',
              width:isDesktop? MediaQuery.of(context).size.width * 0.09 :150,
            ),
            TableItem(
              text: '${info['creationDate'] ?? ''}'.substring(0,11),
              width:isDesktop? MediaQuery.of(context).size.width * 0.09 :150,
            ),
            TableItem(
              text: '${info['sourceWarhouse'] ?? ''}',
              width:isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            TableItem(
              text: '${info['destWarhouse'] ?? ''}',
              width: isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            TableItem(
              text: '${info['task'] ?? 'No Records'}',
              width:isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            TableItem(
              text: '${info['sendingUser'] ?? ''}',
              width: isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            TableItem(
              text:'${info['receivingUser'] ?? ''}',
              width: isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            TableItem(
              text: '${info['receivingDate'] ?? ''}'.length>11 ? '${info['receivingDate'] ?? ''}'.substring(0,11) :'',
              width: isDesktop? MediaQuery.of(context).size.width * 0.07 :150,
            ),
            SizedBox(
              width:isDesktop? MediaQuery.of(context).size.width * 0.13 :150,
              child: Center(
                child: Container(
                  width: '${info['status']}'.length * 12.0,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: info['status'] == "fully received"
                          ? Others.greenStatusColor
                          : info['status'] == 'incomplete'
                          ? Others.orangeStatusColor
                          : info['status'] == 'canceled'
                          ? Others.redStatusColor
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: Text(
                        '${info['status'] ?? ''}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width * 0.03,
              child: ReusableMore(itemsList: [
                PopupMenuItem<String>(
                  value: '1',
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return   PrintTransferIn(
                            transferNumber:  info['transferNumber']??'',
                            receivedDate:info['receivingDate']!=null? info['receivingDate'].substring(0,11):'',
                            creationDate: info['creationDate'].substring(0,11),
                            ref:info['reference']??'',
                            transferTo: info['destWarhouse']??'',
                            receivedUser: info['receivingUser']??'',
                            senderUser:info['sendingUser']??'',
                            status: info['status']??'',
                            transferFrom: info['sourceWarhouse']??'',
                            rowsInListViewInTransfer: info['transferItems'],
                          );
                        }));
                  },
                  child: Text('print'.tr),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}




class MobileTransfersSummary extends StatefulWidget {
  const MobileTransfersSummary({super.key});

  @override
  State<MobileTransfersSummary> createState() => _MobileTransfersSummaryState();
}

class _MobileTransfersSummaryState extends State<MobileTransfersSummary> {
  final TextEditingController filterController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  double listViewLength = 100;
  String selectedNumberOfRows = '10';
  int selectedNumberOfRowsAsInt=10;
  int start = 1;
  bool isArrowBackClicked = false;
  bool isArrowForwardClicked = false;
  final HomeController homeController = Get.find();
  bool isNumberOrderedUp=true;
  bool isCreationOrderedUp=true;
  bool isCustomerOrderedUp=true;
  bool isSalespersonOrderedUp=true;
  final TransferController transferController = Get.find();

  @override
  void initState() {
    listViewLength = Sizes.deviceHeight * (0.09 * transferController.transfersList.length);
    transferController.getAllTransactionsFromBack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferController>(
      builder: (cont) {
        return Container(
          padding:  EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.02),
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(text: 'transfers'.tr),
                gapH10,
                ReusableButtonWithColor(
                  width: homeController.isTablet? MediaQuery.of(context).size.width * 0.6:MediaQuery.of(context).size.width * 0.4,
                  height: 45,
                  onTapFunction: () {
                    homeController.selectedTab.value = 'transfer_out';
                  },
                  btnText: 'create_new_transfer'.tr,
                ),
                gapH10,
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.59,
                  child: ReusableSearchTextField(
                    hint: '${"search".tr}...',
                    textEditingController: searchController,
                    onChangedFunc: () {},
                    validationFunc: () {},
                  ),
                ),
                gapH24,
                ReusableChip(
                  name: 'all_Transfers'.tr,
                ),
                SizedBox(
                  height: listViewLength+150,
                  child: SingleChildScrollView(
                    child: Row(
                      children: [ Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                                decoration: BoxDecoration(
                                    color: Primary.primary,
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                                child: Row(
                                  children: [
                                    tableTitleWithOrderArrow('number'.tr,
                                        150, () {
                                          setState(() {
                                            isNumberOrderedUp=!isNumberOrderedUp;
                                            isNumberOrderedUp
                                                ? cont.transfersList.sort((a, b) => a['transferNumber'].compareTo(b['transferNumber']))
                                                : cont.transfersList.sort((a, b) => b['transferNumber'].compareTo(a['transferNumber']));
                                          });
                                        }),
                                    tableTitleWithOrderArrow('creation'.tr,
                                        150, () {
                                          setState(() {
                                            isCreationOrderedUp=!isCreationOrderedUp;
                                            isCreationOrderedUp?
                                            cont.transfersList.sort((a, b) => a['createdAtDate'].compareTo(b['createdAtDate']))
                                                :cont.transfersList.sort((a, b) => b['createdAtDate'].compareTo(a['createdAtDate']));
                                          });
                                        }),
                                    //todo
                                    TableTitle(
                                      text: 'task'.tr,
                                      width: 150,
                                    ),
                                    TableTitle(
                                      text: 'total'.tr,
                                      width:150,
                                    ),
                                    TableTitle(
                                      text: 'status'.tr,
                                      width:150,
                                    ),
                                    TableTitle(
                                        text: 'more_options'.tr,
                                        width:100
                                    ),
                                  ],
                                ),
                              ),
                              cont.isTransactionsFetched
                                  ?Container(
                                color: Colors.white,
                                child: Column(
                                  children: List.generate(
                                    cont.transfersList.length>9?selectedNumberOfRowsAsInt:cont.transfersList.length,
                                        (index) =>Column(
                                      children: [
                                        Row(
                                          children: [
                                            TransfersAsRowInTable(
                                              info: cont.transfersList[index],
                                              index: index,
                                              isDesktop: false,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.03,
                                                    child:  const ReusableMore(
                                                      itemsList: [],),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.03,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        // var res= await deleteTransfer('${transfersList[index]['id']}');
                                                        // if(res.statusCode==200){
                                                        //   CommonWidgets.snackBar('Success', res['message']);
                                                        //   setState(() {
                                                        //     selectedNumberOfRowsAsInt=selectedNumberOfRowsAsInt-1;
                                                        //     transfersList.removeAt(index);
                                                        //     listViewLength=listViewLength-0.09;
                                                        //   });
                                                        // }else{
                                                        //   CommonWidgets.snackBar('error',
                                                        //       res['message']);
                                                        // }
                                                      },
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        color: Primary.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  ),
                                ),
                              ):const CircularProgressIndicator(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'rows_per_page'.tr}:  ',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.black, width: 2)),
                                    child: Center(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          borderRadius: BorderRadius.circular(0),
                                          items: ['10', '20', '50', 'all'.tr]
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    fontSize: 12, color: Colors.grey),
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedNumberOfRows,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedNumberOfRows = val!;
                                              if(val=='10'){
                                                listViewLength = cont.transfersList.length < 10
                                                    ?Sizes.deviceHeight * (0.09 * cont.transfersList.length)
                                                    : Sizes.deviceHeight * (0.09 * 10);
                                                selectedNumberOfRowsAsInt=cont.transfersList.length < 10? cont.transfersList.length:10;
                                              }if(val=='20'){
                                                listViewLength = cont.transfersList.length < 20
                                                    ? Sizes.deviceHeight * (0.09 * cont.transfersList.length)
                                                    : Sizes.deviceHeight * (0.09 * 20);
                                                selectedNumberOfRowsAsInt=cont.transfersList.length < 20? cont.transfersList.length:20;
                                              }if(val=='50'){
                                                listViewLength = cont.transfersList.length < 50
                                                    ? Sizes.deviceHeight * (0.09 * cont.transfersList.length)
                                                    : Sizes.deviceHeight * (0.09 * 50);
                                                selectedNumberOfRowsAsInt=cont.transfersList.length < 50? cont.transfersList.length:50;
                                              }if(val=='all'.tr){
                                                listViewLength = Sizes.deviceHeight * (0.09 * cont.transfersList.length);
                                                selectedNumberOfRowsAsInt= cont.transfersList.length;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  gapW16,
                                  Text(selectedNumberOfRows=='all'.tr?'${'all'.tr} of ${cont.transfersList.length}':'$start-$selectedNumberOfRows of ${cont.transfersList.length}',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  gapW16,
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isArrowBackClicked = !isArrowBackClicked;
                                          isArrowForwardClicked = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.skip_previous,
                                            color: isArrowBackClicked
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                          Icon(
                                            Icons.navigate_before,
                                            color: isArrowBackClicked
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                        ],
                                      )),
                                  gapW10,
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isArrowForwardClicked = !isArrowForwardClicked;
                                          isArrowBackClicked = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.navigate_next,
                                            color: isArrowForwardClicked
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                          Icon(
                                            Icons.skip_next,
                                            color: isArrowForwardClicked
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                        ],
                                      )),
                                  gapW40,
                                ],
                              )
                            ],
                          ),
                        ),
                      ),],
                    ),
                  ),)
              ],
            ),
          ),
        );
      }
    );
  }

  String hoverTitle = '';
  String clickedTitle = '';
  bool isClicked = false;
  tableTitleWithOrderArrow(String text, double width, Function onClickedFunc) {
    return SizedBox(
      width: width,
      child: Center(
        child: InkWell(
          onTap: () {
            setState(() {
              clickedTitle = text;
              hoverTitle = '';
              isClicked = !isClicked;
              onClickedFunc();
            });
          },
          onHover: (val) {
            if (val) {
              setState(() {
                hoverTitle = text;
              });
            } else {
              setState(() {
                hoverTitle = '';
              });
            }
          },
          child: clickedTitle == text
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              isClicked
                  ? const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
                  : const Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              )
            ],
          )
              : hoverTitle == text
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$text...',
                  style: TextStyle(
                      color: Colors.white.withAlpha((0.5 * 255).toInt()),
                      fontWeight: FontWeight.bold)),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white.withAlpha((0.5 * 255).toInt()),
              )
            ],
          )
              : Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
