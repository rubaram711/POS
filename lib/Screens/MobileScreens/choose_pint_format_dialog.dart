import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import '../../../const/Sizes.dart';
import '../../const/colors.dart';
import '../../const/constants.dart';
import 'mobile_print_invoice_screen.dart';




class ChoosePrintFormatDialog extends StatefulWidget {
  const ChoosePrintFormatDialog({super.key});
  @override
  State<ChoosePrintFormatDialog> createState() =>
      _ChoosePrintFormatDialogState();
}

class _ChoosePrintFormatDialogState extends State<ChoosePrintFormatDialog> {
  // int selectedClientType = 0;
  PaperType? _selectedType;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.25,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DialogTitle(text:'select_print_format'.tr,),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: Primary.primary,
                  radius: 13,
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          gapH32,
          RadioListTile<PaperType>(
            title: Text("A4"),
            value: PaperType.a4,
            groupValue: _selectedType,
            onChanged: (value) {
              setState(() => _selectedType = value);
              Get.back();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MobilePrintScreen(paperType: value!),
                ),
              );
            },
          ),
          RadioListTile<PaperType>(
            title: Text("Roll 80mm"),
            value: PaperType.roll80,
            groupValue: _selectedType,
            onChanged: (value) {
              setState(() => _selectedType = value);
                      Get.back();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MobilePrintScreen(paperType: value!),
                        ),
                      );
            },
          ),
          // Expanded(
          //   // width: MediaQuery.of(context).size.width * 0.3,
          //   child: ListTile(
          //     contentPadding: EdgeInsets.zero,
          //     title: Text(
          //       'roll80',
          //     ),
          //     leading: Radio(
          //       value: 1,
          //       groupValue: selectedClientType,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedClientType = value!;
          //         });
          //         Get.back();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => MobilePrintScreen(paperType: value!),
          //           ),
          //         );
          //
          //       },
          //     ),
          //   ),
          // ),
          // Expanded(
          //   // width: MediaQuery.of(context).size.width * 0.3,
          //   child: ListTile(
          //     contentPadding: EdgeInsets.zero,
          //     title: Text(
          //       'A4',
          //     ),
          //     leading: Radio(
          //       value: 2,
          //       groupValue: selectedClientType,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedClientType = value!;
          //         });
          //         Get.back();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => MobilePrintScreen(paperType: value!),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
