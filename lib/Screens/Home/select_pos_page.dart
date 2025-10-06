import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/pos_controller.dart';
import 'package:pos_project/Locale_Memory/save_user_info_locally.dart';
import 'package:pos_project/Screens/Authorization/logout.dart';
import 'package:pos_project/Widgets/loading.dart';

import 'roles_page.dart';
import '../../const/colors.dart';

class SelectPosPage extends StatefulWidget {
  const SelectPosPage({super.key});

  @override
  State<SelectPosPage> createState() => _SelectPosPageState();
}

class _SelectPosPageState extends State<SelectPosPage> {
  // This widget is the root of your application.
  final PossController possController = Get.find();
  @override
  void initState() {
    possController.getPossFromBack();
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
        child: GetBuilder<PossController>(
            init: PossController(),
            builder: (controller) {
              return controller.isPossFetched
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.posList.length,
                      itemBuilder: (context, index) {
                        return ReusablePosCard(pos: controller.posList[index]);
                      },
                    )
                  : loading();
            }),
      ),
    );
  }
}

class ReusablePosCard extends StatefulWidget {
  const ReusablePosCard({super.key, required this.pos});
  final Map pos;

  @override
  State<ReusablePosCard> createState() => _ReusablePosCardState();
}

class _ReusablePosCardState extends State<ReusablePosCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PossController>(
        init: PossController(),
        builder: (controller) {
          return Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: isHover ? Primary.primary : Colors.grey[500]),
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width * 0.25,
                  height: 60,
                  child: InkWell(
                    onHover: (value) {
                      setState(() {
                        isHover = value;
                      });
                    },
                    onTap: () async {
                      controller.setSelectedPosName(widget.pos['name']);
                      controller.setSelectedRoleId('${widget.pos['id']}');
                      await savePosIdInfoLocally('${widget.pos['id']}');
                      await savePosNameInfoLocally('${widget.pos['name']}');
                      await saveWarehouseIdInfoLocally(
                          '${widget.pos['warehouse']['id']}');
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const RolesPage();
                      }));
                    },
                    child: Center(
                      child: Text(
                        widget.pos['name'] ?? '',
                        style: TextStyle(
                            fontSize: 20,
                            color: isHover ? Colors.white : Colors.black),
                      ),
                    ),
                  )),
            ],
          );
        });
  }
}
