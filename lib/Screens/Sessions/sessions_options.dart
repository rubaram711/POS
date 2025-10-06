import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/session_controller.dart';
import 'package:pos_project/Screens/Sessions/sessions.dart';
import '../../../const/colors.dart';
import '../Authorization/logout.dart';
import 'open_close_session.dart';


class SessionsOptions extends StatefulWidget {
  const SessionsOptions({super.key});

  @override
  State<SessionsOptions> createState() => _SessionsOptionsState();
}

class _SessionsOptionsState extends State<SessionsOptions> {
  List services=[
    {
      'text':'open_close_session'.tr,
      'route':'open_close_session'
    },
    {
      'text': "SESSIONS".tr,
      'route':'sessions'
    }
  ];

  // var currentSessionId='';
  // bool isShownArrow=false;
  // getCurrentOpenSessionId() async {
  //   var p=await getOpenSessionId();
  //   if('${p['data']}'!='[]'){
  //    // setState(() {
  //      currentSessionId= '${p['data']['id']}';
  //      isShownArrow=true;
  //    // });
  //     // if(currentSessionId==''){
  //     //   setState(() {
  //     //     isShownArrow=true;
  //     //   });
  //     // }
  //   }
  // }
  SessionController sessionController=Get.find();
  HomeController homeController=Get.find();
  @override
  void initState() {
    sessionController.getCurrentOpenSessionId();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: GetBuilder<SessionController>(
        builder: (cont) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05,horizontal:homeController.isMobile.value?10: 50),
            // height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cont.isTheirOpenedSession? InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child:   Icon(Icons.arrow_back,
                          size: 22,
                          // color: Colors.grey,
                          color: Primary.primary),
                    ):const SizedBox(),
                    const LogoutBtn(),
                  ],
                ) ,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:  MediaQuery.of(context).size.width*0.5,
                        child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 15.0,
                            direction: Axis.horizontal,
                            children: services
                                .map((element) => ServiceCard(
                              info:element,
                            ))
                                .toList()),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.info});
  final Map info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: (){
          if(info['route']=='open_close_session'){
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                const AlertDialog(
                  backgroundColor: Colors.white,
                  // contentPadding: EdgeInsets.all(0),
                  // titlePadding: EdgeInsets.all(0),
                  // actionsPadding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(9)),
                  ),
                  elevation: 0,
                  content: OpenCloseSession(),
                )
            );
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const Sessions();
                }));}
        },
        child: Column(
          children: [
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              width:130,
              height: 130,
              color: Primary.primary,
              child:
              Center(
                 child: Text(info['text'],
                   textAlign: TextAlign.center,
                   style: const TextStyle(color: Colors.white,fontSize: 15),)),
              ),
          ],
        ),
      ),
    );
  }
}
