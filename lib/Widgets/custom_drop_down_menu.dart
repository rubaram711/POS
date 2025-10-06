import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/Clients/add_new_customer_dialog.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../const/Sizes.dart';
import '../const/colors.dart';
class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu({super.key, required this.optionsList, required this.rowWidth, required this.textFieldWidth, required this.text, required this.onSelected, required this.hint, required this.btnWidth});
  final List<String> optionsList;
  final double rowWidth;
  final double textFieldWidth;
  final double btnWidth;
  final String text;
  final String hint;
  final Function onSelected;
  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  final TextEditingController controller = TextEditingController();
  String? selectedItem ;
  @override
  void initState() {
    selectedItem  = widget.optionsList[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      width: widget.rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text),
          Row(
            children: [
              DropdownMenu<String>(
                width: widget.textFieldWidth,
                requestFocusOnTap: false,
                hintText: widget.hint,
                inputDecorationTheme: InputDecorationTheme(
                  // filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                  // outlineBorder: BorderSide(color: Colors.black,),
                  enabledBorder:OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                  ),
                ),
                // menuStyle: ,
                dropdownMenuEntries: widget.optionsList
                    .map<DropdownMenuEntry<String>>(
                        (String option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                        // enabled: option.label != 'Grey',
                        // style: MenuItemButton.styleFrom(
                        // foregroundColor: color.color,
                        // ),
                      );
                    }).toList(),
                onSelected: (String? val) {
                  widget.onSelected(val);
                  setState(() {
                    selectedItem = val!;
                  });
                },
              ),
              gapW4,
              ReusableButtonWithColor(btnText: 'add'.tr, onTapFunction: (){
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const AlertDialog(
                      backgroundColor: Colors.white,
                      // contentPadding: EdgeInsets.all(0),
                      // titlePadding: EdgeInsets.all(0),
                      // actionsPadding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(9)),
                      ),
                      elevation: 0,
                      content: CreateClientDialog(),
                    ));
              }, width: widget.btnWidth, height: 49,radius: 9,),
            ],
          )
        ],
      ),
    );
  }
}