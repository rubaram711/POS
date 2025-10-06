import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import '../../../const/colors.dart';
import 'select_cash_tray_number_dialog.dart';
import 'open_close_cash_tray.dart';


class CashTrayOptions extends StatefulWidget {
  const CashTrayOptions({super.key});

  @override
  State<CashTrayOptions> createState() => _CashTrayOptionsState();
}

class _CashTrayOptionsState extends State<CashTrayOptions> {
  List services=[
    {
      'text':'open_close_cash_tray'.tr,
      'route':'open_close_cash_tray'
    },
    {
      'text': "cash_trays_report".tr,
      'route':'cash_trays_report'
    }
  ];
HomeController homeController=Get.find();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05,horizontal: homeController.isMobile.value?10:50),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                  child:   Icon(Icons.arrow_back,
                      size: 22,
                      // color: Colors.grey,
                      color: Primary.primary),
                ),
              ],
            ),
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
          if(info['route']=='open_close_cash_tray'){
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
                  content: OpenCloseCashTray(),
                )
            );
          }else {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => const AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                    ),
                    elevation: 0,
                    content: SelectCashTrayNumberDialog()));
          }
            // Navigator.pushReplacement(context, MaterialPageRoute(
            //     builder: (BuildContext context) {
            //       return const CashTraysReport();
            //     }));
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
