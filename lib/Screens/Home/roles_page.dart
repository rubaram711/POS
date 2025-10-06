import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Locale_Memory/save_user_info_locally.dart';
import 'package:pos_project/Widgets/loading.dart';

import '../../Backend/Roles/select_role.dart';
import '../../Backend/Sessions/get_open_session_id.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/role_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Models/role_model.dart';
import '../Authorization/logout.dart';
import '../MobileScreens/mobile_home.dart';
import '../Sessions/sessions_options.dart';
import 'home_page.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../const/colors.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  // This widget is the root of your application.
  final RoleController roleController = Get.find();
  @override
  void initState() {
    roleController.getRoles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: LogoutBtn(),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 200),
        child: GetBuilder<RoleController>(
            init: RoleController(),
            builder: (controller) {
              return controller.isRolesFetched? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.roles.length,
                itemBuilder: (context, index) {
                  return ReusableRoleCard(role:controller.roles[index]);
                },
              ):loading();
            }),
      ),
    );
  }
}

class ReusableRoleCard extends StatefulWidget {
  const ReusableRoleCard({super.key, required this.role});
  final Role role;

  @override
  State<ReusableRoleCard> createState() => _ReusableRoleCardState();
}

class _ReusableRoleCardState extends State<ReusableRoleCard> {
  bool isHover = false;
  HomeController homeController=Get.find();
  getInfoFromPref() async {
    String name = await getNameFromPref();
    var company = await getCompanyNameFromPref();
    homeController.companyName=company;
    var posName = await getPosTerminalNameFromPref();
    homeController.posName=posName;
    homeController.useName=name;
    var companySubjectToVat=await getCompanySubjectToVatFromPref();
    homeController.companySubjectToVat=companySubjectToVat;
    var vat=getCompanyVatFromPref();
    homeController.vat='$vat';
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoleController>(
        init: RoleController(),
        builder: (controller) {
          return
            Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: isHover ? Primary.primary : Colors.grey[500]),
                    margin: const EdgeInsets.all(10),
                    width:300,//homeController.isMobile.value? MediaQuery.sizeOf(context).width * 0.5:MediaQuery.sizeOf(context).width * 0.25,
                    height: 60,
                    child: InkWell(
                      onHover: (value) {
                        setState(() {
                          isHover = value;
                        });
                      },
                      onTap: () async {
                        var name = widget.role.name.toString();
                        controller.setSelectedRoleName(name);
                        controller.setSelectedRoleId('${widget.role.id}');
                        var res = await selectRole(controller.selectedRoleName);
                        if(res['success'] == true){
                          getInfoFromPref();
                          await saveRoleIdInfoLocally(controller.selectedRoleId);
                          await saveRoleNameInfoLocally(controller.selectedRoleName);
                          var currentSessionId = '';
                          var p = await getOpenSessionId();
                          if ('${p['data']}' != '[]') {
                            currentSessionId = '${p['data']['session']['id']}';
                          }
                          if (currentSessionId == '') {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const SessionsOptions();
                                    }));
                          } else {
                            if(!homeController.isMobile.value){
                            // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const HomePage();
                                      }));
                            }else{
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const MobileHomePage();
                                      }));
                            }
                          }
                        } else {
                          CommonWidgets.snackBar('error', 'error'.tr);
                        }
                      },
                      child: Center(
                        child: Text(
                          widget.role.name??'',
                          style: TextStyle(
                              fontSize: 20,
                              color: isHover ? Colors.white : Colors.black),
                        ),
                      ),
                    )),
              ],
            );
          //   InkWell(
          //   onTap: () async {
          //     // var id = controller.roles[index]['id'].toString();
          //     // controller.setSelectedRoleId(id);
          //     // print(controller.selectedRoleId);
          //     // var res = await selectRole(controller.selectedRoleId);
          //     var name = widget.role.name.toString();
          //     print(name);
          //     controller.setSelectedRoleName(name);
          //     controller.setSelectedRoleId('${widget.role.id}');
          //     var res = await selectRole(controller.selectedRoleName);
          //     if(res['success'] == true){
          //       await saveRoleIdInfoLocally(controller.selectedRoleId);
          //       var currentSessionId = '';
          //       var p = await getOpenSessionId();
          //       if ('${p['data']}' != '[]') {
          //           currentSessionId = '${p['data']['id']}';
          //       }
          //       if (currentSessionId == '') {
          //         // ignore: use_build_context_synchronously
          //         Navigator.pushReplacement(context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) {
          //                   return const SessionsOptions();
          //                 }));
          //       } else {
          //         // ignore: use_build_context_synchronously
          //         Navigator.pushReplacement(context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) {
          //                   return const HomePage();
          //                 }));
          //         // }
          //       }
          //     //todo go to sessions
          //     } else {
          //       CommonWidgets.snackBar('error', 'error'.tr);
          //     }
          //   },
          //   child:Container(
          //     width: MediaQuery.of(context).size.width * 0.5,
          //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //     padding: const EdgeInsets.symmetric( horizontal: 20),
          //     height: 60,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(9),
          //         color: isHovered ? Primary.primary : Colors.grey[500]),
          //     child: Center(
          //       child: Text(
          //         widget.role.name??'',
          //         style: TextStyle(
          //             color: isHovered ? Colors.white : Colors.black,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          //
          //
          //
          //
          //
          //   // Center(
          //   //   child: Column(
          //   //     children: [
          //   //       Container(
          //   //           decoration: BoxDecoration(
          //   //             borderRadius: BorderRadius.circular(10),
          //   //             color: Colors.grey[600],
          //   //           ),
          //   //           margin: const EdgeInsets.all(10),
          //   //           width: MediaQuery.sizeOf(context).width * 0.25,
          //   //           height: 50,
          //   //           child: Center(
          //   //             child: Text(
          //   //               controller.roles[index]['name'],
          //   //               style: const TextStyle(
          //   //                 fontSize: 20,
          //   //                 color: Colors.white,
          //   //               ),
          //   //             ),
          //   //           )),
          //   //     ],
          //   //   ),
          //   // ),
          // );
        });
  }
}
