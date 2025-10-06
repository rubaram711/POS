import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/Sessions/close_session.dart';
import 'package:pos_project/Backend/Sessions/open_session.dart';
import 'package:pos_project/Screens/Sessions/sessions.dart';
import 'package:pos_project/Screens/Home/home_page.dart';
import '../../../Backend/Sessions/get_open_session_id.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/session_controller.dart';
import '../../../Widgets/custom_snak_bar.dart';
import '../../../Widgets/reusable_text_field.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../Home/search_dialog.dart';

class OpenCloseSession extends StatefulWidget {
  const OpenCloseSession({super.key});

  @override
  State<OpenCloseSession> createState() => _OpenCloseSessionState();
}

class _OpenCloseSessionState extends State<OpenCloseSession> {
  TextEditingController noteController = TextEditingController();
  SessionController sessionController = Get.find();
@override
  void initState() {
  // sessionController.setSelectedTabIndex(0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(builder: (cont) {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogTitle(text: 'open_close_session'.tr),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: CircleAvatar(
                    backgroundColor: Primary.primary,
                    radius: 15,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            gapH20,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'note'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                ReusableTextField(
                  isPasswordField: false,
                  onChangedFunc: (val) {
                    noteController.text=val;
                  },
                  validationFunc: (val) {},
                  hint: '',
                  maxLines: 6,
                  textEditingController: noteController,
                ),
              ],
            ),
            gapH20,
            Row(
              children: [
                ReusableTabOpenClose(
                  index: 0,
                  text: 'open'.tr,
                  onTapFunc: () async {
                      var res = await openSession(noteController.text);
                      if (res['success'] == true) {
                        Get.back();
                        CommonWidgets.snackBar(
                            'Success', res['message']);
                        // await saveCurrentOpenSessionIdInfoLocally('${res['data']['id']}');
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const HomePage();
                            }));
                      } else {
                        CommonWidgets.snackBar(
                            'error', res['message'] ?? 'error'.tr);
                      }
                  },
                ),
                ReusableTabOpenClose(
                  index: 1,
                  text: 'close_session'.tr,
                  onTapFunc: () async {
                    var id='';
                    var p=await getOpenSessionId();
                    if('${p['data']}'!='[]'){
                      setState(() {
                        id='${p['data']['session']['id']}';
                      });
                    }
                    // print('start');
                    var res = await closeSession(id, noteController.text);
                    if (res['success'] == true) {
                      Get.back();
                      CommonWidgets.snackBar(
                          'Success', res['message']);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const Sessions();
                          }));
                      // await saveCurrentOpenSessionIdInfoLocally('');
                    } else {
                      CommonWidgets.snackBar(
                          'error', res['message'] ?? 'error'.tr);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ReusableTabOpenClose extends StatefulWidget {
  const ReusableTabOpenClose(
      {super.key, required this.text, required this.index, required this.onTapFunc});
  final String text;
  final int index;
  final Function onTapFunc;
  @override
  State<ReusableTabOpenClose> createState() => _ReusableTabOpenCloseState();
}

class _ReusableTabOpenCloseState extends State<ReusableTabOpenClose> {
  HomeController homeController=Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(builder: (cont) {
      return InkWell(
        onTap: () {
          widget.onTapFunc();
          cont.setSelectedTabIndex(widget.index);
        },
        child: Container(
          width:homeController.isMobile.value? MediaQuery.of(context).size.width * 0.32: MediaQuery.of(context).size.width * 0.34,
          height: 45,
          // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              color: cont.selectedTabIndex == widget.index
                  ? Primary.primary
                  : Primary.p20,
              border: Border(
                top: BorderSide(color: Primary.primary, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cont.selectedTabIndex == widget.index
                      ? Colors.white
                      : Primary.primary),
            ),
          ),
        ),
      );
    });
  }
}
