import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/session_controller.dart';
import 'package:pos_project/Screens/Sessions/sessions_options.dart';
import '../../../Backend/Sessions/get_open_session_id.dart';
import '../../../Widgets/page_title.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../Widgets/table_item.dart';
import '../../../Widgets/table_title.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../Home/home_page.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final SessionController sessionController = Get.find();
  String searchValue = '';
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
    setState(() {
      searchValue = value;
    });
    await sessionController.getSessionsFromBack();
  }
  bool isHomeHovered=false;
  bool isShownHome=false;
  var currentSessionId='';
  getCurrentOpenSessionId() async {
    var p=await getOpenSessionId();
    if('${p['data']}'!='[]'){
      setState(() {
        currentSessionId= '${p['data']['session']['id']}';
        isShownHome=true;
      });
      // if(currentSessionId==''){
      //   setState(() {
      //     isShownArrow=true;
      //   });
      // }
    }

  }
  // final ProductController productController = Get.find();
  // final PaymentController paymentController = Get.find();
  final HomeController homeController = Get.find();
  @override
  void initState() {
    getCurrentOpenSessionId();
    sessionController.getSessionsFromBack();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SessionController>(builder: (cont) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          // height: MediaQuery.of(context).size.height * 0.85,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const SessionsOptions();
                            }));
                          },
                          child: Icon(Icons.arrow_back,
                              size: 22,
                              // color: Colors.grey,
                              color: Primary.primary),
                        ),
                        gapW10,
                        PageTitle(text: 'sessions'.tr),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ReusableSearchTextField(
                            hint: '${"search".tr}...',
                            textEditingController:
                                cont.searchInSessionsController,
                            onChangedFunc: (value) {
                              cont.searchInSessionsController.text = value;
                              _onChangeHandler(value);
                            },
                            validationFunc: (val) {},
                          ),
                        ),
                        isShownHome? Container(
                          margin:const EdgeInsets.symmetric(horizontal: 6),
                          child: InkWell(
                            onHover: (val){
                              setState(() {
                                isHomeHovered=val;
                              });
                            },
                            child: Icon(Icons.home,size: 30,color:isHomeHovered?Primary.primary: Colors.grey,),
                            onTap: () {
                              // productController.resetAll();
                              // paymentController.resetAll();
                              if(homeController.isMobile.value){
                              Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                              return const HomePage();
                              }));
                              }else{
                              homeController.selectedTab.value='Home';
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Get.off(() => const HomeBody());
                              });}
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) {
                              //   return const HomePage();
                              // }));
                            },
                          ),
                        ):const SizedBox()
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                homeController.isMobile.value?
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Primary.primary,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      TableTitle(
                                        text: 'session'.tr,
                                        width: 140,
                                      ),
                                      TableTitle(
                                        text: 'pos_name'.tr,
                                          width: 140,
                                      ),
                                      TableTitle(
                                        text: 'opened_by'.tr,
                                          width: 140,
                                      ),
                                      TableTitle(
                                        text: 'closed_by'.tr,
                                        width: 140,
                                      ),
                                      TableTitle(
                                        text: 'opening_date'.tr,
                                        width: 140,
                                      ),
                                      TableTitle(
                                        text: 'closing_date'.tr,
                                        width: 140,
                                      ),
                                      TableTitle(
                                        text: 'status'.tr,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ),
                                cont.isSessionsFetched
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: List.generate(
                                    cont.sessionsList.length,
                                        (index) => Column(
                                          children: [
                                            SessionsAsRowInTable(
                                              info: cont.sessionsList[index],
                                              index: index,
                                            ),
                                            const Divider()
                                          ],
                                        ),
                                  ),
                                )
                                    : const CircularProgressIndicator(),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                :Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Primary.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TableTitle(
                            text: 'session'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'pos_name'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'opened_by'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'closed_by'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'opening_date'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'closing_date'.tr,
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          TableTitle(
                            text: 'status'.tr,
                            width: MediaQuery.of(context).size.width * 0.13,
                          ),
                        ],
                      ),
                    ),
                    cont.isSessionsFetched
                        ? Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.width * 0.9, // listViewLength,
                            child: ListView.builder(
                              itemCount: cont.sessionsList
                                  .length, // cont.transfersList.length>9?selectedNumberOfRowsAsInt: cont.transfersList.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  SessionsAsRowInTable(
                                    info: cont.sessionsList[index],
                                    index: index,
                                  ),
                                  const Divider()
                                ],
                              ),
                            ),
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SessionsAsRowInTable extends StatelessWidget {
  const SessionsAsRowInTable(
      {super.key,
      required this.info,
      required this.index,
      this.isDesktop = true});
  final Map info;
  final int index;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    // final TransferController transferController = Get.find();
    return
        // InkWell(
        // onDoubleTap: (){
        //   if(info['status'] == 'sent') {
        //     homeController.selectedTab.value = 'transfer_in';
        //   }else{
        //     homeController.selectedTab.value = 'transfer_details';
        //   }
        //   transferController.setSelectedTransferIn(info);
        //   transferController.addToRowsInListViewInTransferIn(info['transferItems']);
        // },
        // child:
        Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TableItem(
            text: '${info['sessionNumber'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${info['posName'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${info['openedBy'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${info['closedBy'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${info['openingDate'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${info['closingDate'] ?? ''}',
            width:homeController.isMobile.value? 140: MediaQuery.of(context).size.width * 0.1,
          ),
          SizedBox(
            width:homeController.isMobile.value? 150: MediaQuery.of(context).size.width * 0.13,
            child: Center(
              child: Container(
                width: '${info['status']}'.length * 12.0,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                    color: Others.greenStatusColor,
                    // info['status'] == "fully received"
                    //     ? Others.greenStatusColor
                    //     : info['status'] == 'incomplete'
                    //     ? Others.orangeStatusColor
                    //     : info['status'] == 'canceled'
                    //     ? Others.redStatusColor
                    //     : Colors.blue,
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
        ],
      ),
    );
    // );
  }
}


